# rubocop:disable Layout/LineLength
describe "SIU^S15 - Notification of Appointment Cancellation" do
  # A notification of appointment cancellation is sent by the filler application to other
  # applications when an existing appointment has been canceled. A cancel event is used to stop a
  # valid appointment from taking place. For example, if a patient scheduled for an exam cancels
  # his/her appointment, then the appointment is canceled on the filler application.

  # Example message:

  #   MSH|^~\&|BLT_TIE|BLT|RENALWARE|MSE|20241107153747||SIU^S15|Q166123117|P|2.4
  #   SCH|149549027|||||6080524|Nephrology Haemodialysis F/Up||60|MINUTES|^^60^20241113100000^20241113110000||||||||||||||Cancelled
  #   PID|1||10769859^^^KCH^MRN||MOLLY^RENALTESTFIVE^^^^^CURRENT||19870101|2|||51 Sidney Street^^^LONDON^E1 2GB^^HOME^^||07898989898^MOBILE~0209999998^HOME~testemail@test.co^EMAIL|""^BUSINESS||""||13401074||||N||||||||N
  #   PD1|||THE CHRISP STREET HTH CTR^^F84062|G9401882^SMALL^AM^^^^^^EXTID
  #   PV1|1|O|RNJ Renal SBH^^^RNJ BARTS^^AMB^RNJ KGV|""|||C3590850|G9401882||361||||""||||PREADMIT|24301156^^^RNJATTNUM^VISITID|||||||||||||||||""|""||RNJ BARTS||||||
  #   RGS|1
  #   AIG|1||RNJ Chester, Dr Brook - Nurse 2
  #   AIL|1||RNJ Renal SBH^^^RNJ BARTS^^AMB^RNJ KGV

  include HL7Helpers
  include PatientsSpecHelper

  let(:visit_number) { "123" }

  let(:raw_hl7) do
    hl7 = <<-HL7
      MSH|^~\&|BLT_TIE|BLT|RENALWARE|MSE|20241107153747||SIU^S15|Q166123117|P|2.4
      SCH|#{visit_number}|||||6080524|Nephrology Haemodialysis F/Up||60|MINUTES|^^60^20241113100000^20241113110000||||||||||||||Cancelled
      PID|1||10769859^^^KCH^MRN||MOLLY^RENALTESTFIVE^^^^^CURRENT||19870101|2|||51 Sidney Street^^^LONDON^E1 2GB^^HOME^^||07898989898^MOBILE~0209999998^HOME~testemail@test.co^EMAIL|""^BUSINESS||""||13401074||||N||||||||N
      PD1|||THE CHRISP STREET HTH CTR^^F84062|G9401882^SMALL^AM^^^^^^EXTID
      PV1|1|O|RNJ Renal SBH^^^RNJ BARTS^^AMB^RNJ KGV|""|||C3590850|G9401882||361||||""||||PREADMIT|24301156^^^RNJATTNUM^VISITID|||||||||||||||||""|""||RNJ BARTS||||||
      RGS|1
      AIG|1||RNJ Chester, Dr Brook - Nurse 2
      AIL|1||RNJ Renal SBH^^^RNJ BARTS^^AMB^RNJ KGV
    HL7
    hl7.gsub(/^ */, "")
  end

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
    it "hard deletes it" do
      patient = create_patient

      Renalware::Clinics::Appointment.create!(
        visit_number: visit_number,
        starts_at: Time.zone.parse("20241105101500"),
        ends_at: Time.zone.parse("20241105104500"),
        patient: patient,
        consultant: create(:consultant, code: "CONSULTANT1", name: "Dr A B"),
        clinic: create(:clinic, code: "CLINIC1")
      )

      msg = hl7_message_from_raw_string(raw_hl7)

      expect {
        Renalware::Clinics::Ingestion::Commands::DeleteAppointment.call(msg)
      }.to change(Renalware::Clinics::Appointment, :count).by(-1)
    end
  end

  context "when the appointment does not exist" do
    it "does nothing" do
      create_patient

      msg = hl7_message_from_raw_string(raw_hl7)

      expect {
        Renalware::Clinics::Ingestion::Commands::DeleteAppointment.call(msg)
      }.not_to change(Renalware::Clinics::Appointment, :count)
    end
  end
end
# rubocop:enable Layout/LineLength
