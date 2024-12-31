# rubocop:disable Layout/LineLength
describe "HL7 SIU^S13 - Notification of Appointment Rescheduling" do
  # This message is sent from a filler application to notify other applications that an existing
  # appointment has been rescheduled. The information in the SCH segment and the other detail
  # segments as appropriate describe the new date(s) and time(s) to which the previously booked
  # appointment has been moved. Additionally, it describes the unchanged information in the
  # previously booked appointment.

  # Example message:
  #   MSH|^~\&|BLT_TIE|BLT|RENALWARE|MSE|20241107154347||SIU^S13|Q1663236015T1667362682A1117|P|2.4
  #   SCH|149549023|||||Undo Cancel|Nephrology New||30|MINUTES|^^30^20241106113000^20241106120000||||||||||||||Confirmed
  #   PID|1||10769861^^^RNJ 5C4 MRN^MRN||MOLLY^RENALEIGHT^^^^^CURRENT||19870101|2|||166 Rush Home Road^^^ROMFORD^AN7 0JR^^HOME^^||0789898989^MOBILE~0209999999^HOME~testrenal@co.in^EMAIL|""^BUSINESS||M||13401076||||P||||||||N
  #   PD1|||THE CHRISP STREET HTH CTR^^F84062|G999^SMALL^AM^^^^^^EXTID
  #   PV1|1|O|RNJ Renal OPD^^^RNJ ROYALLONDON^^AMB^RNJ MainBld RLH|""|||Z3590850|G999||361||||""||||OPREFERRAL|924301153^^^RNJATTNUM^VISITID|||||||||||||||||""|""||RNJ ROYALLONDON||||||
  #   RGS|1
  #   AIG|1||Stevens, Stanley
  #   AIL|1||RNJ Renal OPD^^^RNJ ROYALLONDON^^AMB^RNJ MainBld RLH

  include HL7Helpers
  include PatientsSpecHelper

  let(:visit_number) { "123" }
  let(:raw_hl7) do
    hl7 = <<-HL7
      MSH|^~\&|BLT_TIE|BLT|RENALWARE|MSE|20241107154347||SIU^S13|Q1663236015T1667362682A1117|P|2.4
      SCH|#{visit_number}|||||Undo Cancel|Nephrology New||30|MINUTES|^^30^#{starts_at}^#{ends_at}||||||||||||||Confirmed
      PID|1||10769861^^^KCH^MRN||MOLLY^RENALEIGHT^^^^^CURRENT||19870101|2|||166 Rush Home Road^^^ROMFORD^AN7 0JR^^HOME^^||0789898989^MOBILE~0209999999^HOME~testrenal@co.in^EMAIL|""^BUSINESS||M||13401076||||P||||||||N
      PD1|||THE CHRISP STREET HTH CTR^^F84062|G999^SMALL^AM^^^^^^EXTID
      PV1|1|O|#{clinic_code}^^^RNJ ROYALLONDON^^AMB^RNJ MainBld RLH|""|||CONSULTANT2^Smith^John^^^Dr^NHSCONSULTANTNUMBER^PRSNL^^^NONGP|G999||361||||""||||OPREFERRAL|924301153^^^RNJATTNUM^VISITID|||||||||||||||||""|""||RNJ ROYALLONDON||||||
      RGS|1
      AIG|1||Stevens, Stanley
      AIL|1||RNJ Renal OPD^^^RNJ ROYALLONDON^^AMB^RNJ MainBld RLH
    HL7
    hl7.gsub(/^ */, "")
  end

  def create_patient
    create(
      :clinics_patient,
      local_patient_id: "10769861",
      given_name: "MOLLY",
      family_name: "RENALEIGHT",
      born_on: Date.parse("19870101")
    ).tap do |pat|
      pat.current_address.update!(postcode: "RG7 0JB")
    end
  end

  def create_appointment(patient, consultant, clinic, starts_at, ends_at)
    Renalware::Clinics::Appointment.create!(
      visit_number: visit_number,
      starts_at: starts_at,
      ends_at: ends_at,
      patient: patient,
      consultant: consultant,
      clinic: clinic
    )
  end

  before do
    create(:user, :system)
    create(:modality_change_type, :default)
  end

  context "when the appointment already exists in RW" do
    let(:starts_at)       { "20241106114500" }
    let(:ends_at)         { "20241106123000" }
    let(:clinic_code)     { "CLINIC2" }
    let(:consultant_code) { "CONSULTANT2" }

    it "updates it with the new details" do
      patient = create_patient

      # initially the appointment is at 2024 Nov 05 10:15:00 for 30 mins at clinic CLINIC1
      initial_starts_at   = Time.zone.parse("20241105101500")
      initial_ends_at     = Time.zone.parse("20241105104500")
      initial_clinic      = create(:clinic, code: "CLINIC1")
      initial_consultant  = create(:consultant, code: "CONSULTANT1", name: "Dr A B")

      # rescheduled appointment is at 2024 Nov 06 11:45:00 for 45 mins
      create_appointment(
        patient,
        initial_consultant,
        initial_clinic,
        initial_starts_at,
        initial_ends_at
      )

      # Preflight check
      expect(patient.appointments.last).to have_attributes(
        starts_at: initial_starts_at,
        ends_at: initial_ends_at,
        clinic: initial_clinic,
        consultant: initial_consultant
      )

      msg = hl7_message_from_raw_string(raw_hl7)

      new_clinic      = create(:clinic, code: clinic_code)
      new_consultant  = create(:consultant, code: consultant_code, name: "Dr X Y")

      expect {
        Renalware::Clinics::Ingestion::Commands::CreateOrUpdateAppointment.call(msg)
      }.not_to change(Renalware::Clinics::Appointment, :count)

      expect(patient.appointments.count).to eq(1)
      expect(patient.appointments.last).to have_attributes(
        starts_at: Time.zone.parse(starts_at),
        ends_at: Time.zone.parse(ends_at),
        clinic: new_clinic,
        consultant: new_consultant
      )
    end
  end

  context "when the appointment does not exist in RW yet" do
    let(:starts_at)       { "20241106114500" }
    let(:ends_at)         { "20241106123000" }
    let(:clinic_code)     { "CLINIC2" }
    let(:consultant_code) { "CONSULTANT2" }

    it "creates it" do
      patient = create_patient

      expect(patient.appointments.count).to eq(0)

      msg = hl7_message_from_raw_string(raw_hl7)

      clinic      = create(:clinic, code: clinic_code)
      consultant  = create(:consultant, code: consultant_code, name: "Dr X Y")

      expect {
        Renalware::Clinics::Ingestion::Commands::CreateOrUpdateAppointment.call(msg)
      }.to change(Renalware::Clinics::Appointment, :count).by(1)

      expect(patient.appointments.count).to eq(1)
      expect(patient.appointments.last).to have_attributes(
        starts_at: Time.zone.parse(starts_at),
        ends_at: Time.zone.parse(ends_at),
        clinic: clinic,
        consultant: consultant
      )
    end
  end
end
# rubocop:enable Layout/LineLength
