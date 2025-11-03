# rubocop:disable Layout/LineLength
describe "SIU^S26 - Notification that patient did not show up for schedule appointment" do
  # A notification that a patient did not show up for an appointment. For example, if a patient was
  # scheduled for a clinic visit, and never arrived for that appointment, this trigger event can be
  # used to set a status on the appointment record for statistical purposes, as well as to free
  # resources assigned to the appointment (or any other application level actions that must be taken
  # in the event a patient does not appear for an appointment).

  # Example message:

  #   MSH|^~\&|BLT_TIE|BLT|RENALWARE|MSE|20241107153747||SIU^S26|Q166123117|P|2.4
  #   SCH|149549027|||||6080524|Nephrology Haemodialysis F/Up||60|MINUTES|^^60^20241113100000^20241113110000||||||||||||||Cancelled
  #   PID|1||10769859^^^Dover^MRN||MOLLY^RENALTESTFIVE^^^^^CURRENT||19870101|2|||51 Sidney Street^^^LONDON^E1 2GB^^HOME^^||07898989898^MOBILE~0209999998^HOME~testemail@test.co^EMAIL|""^BUSINESS||""||13401074||||N||||||||N
  #   PD1|||THE CHRISP STREET HTH CTR^^F84062|G9401882^SMALL^AM^^^^^^EXTID
  #   PV1|1|O|RNJ Renal SBH^Nephrology Haemodialysis F/Up^^RNJ BARTS^^AMB^RNJ KGV|""|||C3590850|G9401882||361||||""||||PREADMIT|24301156^^^RNJATTNUM^VISITID|||||||||||||||||""|""||RNJ BARTS||||||
  #   RGS|1
  #   AIG|1||RNJ Chester, Dr Brook - Nurse 2
  #   AIL|1||RNJ Renal SBH^^^RNJ BARTS^^AMB^RNJ KGV

  include HL7Helpers
  include PatientsSpecHelper

  let(:starts_at)       { "20241106114500" }
  let(:ends_at)         { "20241106123000" }
  let(:visit_number) { "123" }
  let(:clinic_code) { "Clinic1Code" }
  let(:clinic_name) { "Clinic1Name" }
  let(:consultant_code) { "CONSULTANT2" }
  let(:clinic) { create(:clinic, code: clinic_code, name: clinic_name) }
  let(:consultant) { create(:consultant, code: consultant_code, name: "Dr X Y") }
  let(:raw_hl7) do
    hl7 = <<-HL7
      MSH|^~\&|BLT_TIE|BLT|RENALWARE|MSE|20241106150701||SIU^S26|Q166323123117|P|2.4
      SCH|149549015||||||clinic_name_copied_into_PV3.1||30|MINUTES|^^30^20241106114500^20241106123000||||||||||||||Confirmed
      PID|1||10769859^^^Dover||RENALTESTFIVE^MOLLY^^^^^CURRENT||19870101|2|||21 Rush Home Road^^^ROMFORD^RG7 0JB^^HOME^^||0766655652^MOBILE~02011110111^HOME~testrenal@test.co^EMAIL|""^BUSINESS||""||13401071||||H||||||||N
      PD1|||THE CHRISP STREET HTH CTR^^F84062|G999^SMAILL^AM^^^^^^EXTID
      PV1|1|O|#{clinic_code}^#{clinic_name}^^RNJ ROYALLONDON^^AMB^RNJ MainBld RLH|""|||#{consultant_code}^Y^X^^^Dr^NHSCONSULTANTNUMBER^PRSNL^^^NONGP|G9123^Jones^JP||361||||""||||OPREFERRAL|924301148^^^RNJATTNUM^VISITID|||||||||||||||||""|""||RNJ ROYALLONDON||||||
      RGS|1
      AIG|1||Baxter, Stanley
      AIL|1||clinic_code_copied_into_PV3.1^^^RNJ ROYALLONDON^^AMB^RNJ MainBld RLH
    HL7
    hl7.gsub(/^ */, "")
  end

  before { create(:user, :system) }

  def create_patient
    create(
      :clinics_patient,
      local_patient_id: "10769859",
      given_name: "MOLLY",
      family_name: "RENALTESTFIVE",
      born_on: Date.parse("19870101")
    ).tap do |pat|
      pat.current_address.update!(postcode: "RG7 0JB")
    end
  end

  context "when the appointment exists" do
    it "does nothing as we do not currently capture a DNA for existing appointment" do
      patient = create_patient

      Renalware::Clinics::Appointment.create!(
        visit_number: visit_number,
        starts_at: Time.zone.parse("20241105101500"),
        ends_at: Time.zone.parse("20241105104500"),
        patient: patient,
        consultant: consultant,
        clinic: clinic
      )

      msg = hl7_message_from_raw_string(raw_hl7)

      expect {
        Renalware::Clinics::Ingestion::Commands::DeleteAppointment.call(msg)
      }.not_to change(Renalware::Clinics::Appointment, :count)
    end
  end

  context "when the appointment does not exist in RW yet" do
    it "creates it" do
      patient = create_patient
      consultant
      clinic

      expect(patient.appointments.count).to eq(0)

      msg = hl7_message_from_raw_string(raw_hl7)

      expect {
        Renalware::Clinics::Ingestion::Commands::CreateOrUpdateAppointment.call(msg)
      }.to change(Renalware::Clinics::Appointment, :count).by(1)

      expect(patient.reload.appointments.count).to eq(1)
      appointment = patient.appointments.last
      expect(appointment).to have_attributes(
        starts_at: Time.zone.parse(starts_at),
        ends_at: Time.zone.parse(ends_at),
        clinic_id: clinic.id,
        consultant_id: consultant.id
      )
    end
  end
end
# rubocop:enable Layout/LineLength
