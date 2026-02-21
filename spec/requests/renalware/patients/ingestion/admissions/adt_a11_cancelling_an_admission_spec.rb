# An A11 event is used to cancel an admission that was entered in error.
# It should delete the previously created admission record.

# rubocop:disable Layout/LineLength
# Example message:
#   MSH|^~\&|Cerner|RYJ|Renalware|Renalware|20250915155356||ADT^A11|123|P|2.3||||||8859/1
#   EVN|A11|20250915155356
#   PID|1|9715587437^^^NHS|40209200^^^RYJ MRN||BB^AA^MN^^MR^^CURRENT||19501010|1|||Flat 1^CX Court^LONDON^""^E6 1AA^GBR^HOME^High Street South||07563553443^^MOBILE~123^^A@B@EMAIL.COM^^EMAIL|123^BUSINESS||M|CHRISTIAN|||||F|||||||
#   PD1|||PRACTICEA^^E86010|^^^^^^
#   PV1|1|I|SM DOUG^Bay C^Bed 14^St Mary's^^BED^SM QEQM|||SM DOUG^Bay C^Bed 14^St Mary's^^BED^SM QEQM||||361|||||||||19894462|||||||||||||||||||||||||20250915094800|
# rubocop:enable Layout/LineLength
describe "HL7 ADT^A11 message handling: 'Cancel admission'" do
  include HL7Helpers
  include PatientsSpecHelper

  let(:visit_number) { "19894462" }
  let(:system_user) { create(:user, :system) }
  let(:unit) { "St Mary's" }
  let(:ward) { "SM DOUG" }
  let(:room) { "Bay C" }
  let(:bed) { "Bed 14" }
  let(:building) { "SM QEQM" }
  let(:floor) { "" }
  let(:consultant_code) { "" }

  let(:raw_hl7) do
    hl7 = <<-HL7
      MSH|^~\&|Cerner|RYJ|Renalware|Renalware|20250915155356||ADT^A11|123|P|2.3
      EVN|A11|20250915155356
      PID|1||40209200^^^Dover||BB^AA^^^^^CURRENT||19501010|1|||Flat 1^CX Court^LONDON^^E6 1AA^^HOME^^||07563553443^^MOBILE~123^^A@B@EMAIL.COM^^EMAIL|123^BUSINESS||M||||||||||||||
      PD1|||PRACTICEA^^E86010|^^^^^^
      PV1|1|I|#{ward}^#{room}^#{bed}^#{unit}^^BED^#{building}^#{floor}||||||||||||||||#{visit_number}|||||||||||||||||||||||||20250915094800|
    HL7
    hl7.gsub(/^ */, "")
  end

  before do
    system_user
    create(:modality_change_type, :default)
  end

  def create_patient
    create(
      :patient,
      local_patient_id: "40209200",
      given_name: "AA",
      family_name: "BB",
      born_on: Date.parse("1950-10-10")
    ).tap do |pat|
      pat.current_address.update!(postcode: "E6 6JD")
    end
  end

  context "when the patient exists and has an admission with the matching visit number" do
    it "deletes the admission" do
      patient = create_patient
      hospital_centre = create(:hospital_centre, host_site: true)
      hospital_unit = create(
        :hospital_unit,
        hospital_centre:,
        unit_code: unit
      )
      hospital_ward = create(
        :hospital_ward,
        code: ward,
        hospital_unit:
      )

      # Create an existing admission with the visit number from the A11 message
      create(
        :admissions_admission,
        patient:,
        hospital_ward:,
        visit_number:,
        admitted_on: Date.parse("20250915")
      )

      msg = hl7_message_from_raw_string(raw_hl7)

      expect {
        Renalware::Admissions::Ingestion::Commands::CancelAdmission.call(msg)
      }.to change(Renalware::Admissions::Admission, :count).by(-1)
    end
  end

  context "when the patient exists but has no admission with the matching visit number" do
    it "does not delete anything" do
      patient = create_patient
      hospital_centre = create(:hospital_centre, host_site: true)
      hospital_unit = create(
        :hospital_unit,
        hospital_centre:,
        unit_code: unit
      )
      hospital_ward = create(
        :hospital_ward,
        code: ward,
        hospital_unit:
      )

      # Create an admission with a different visit number
      other_admission = create(
        :admissions_admission,
        patient:,
        hospital_ward:,
        visit_number: "different_visit_number",
        admitted_on: Date.parse("20250915")
      )

      msg = hl7_message_from_raw_string(raw_hl7)

      expect {
        Renalware::Admissions::Ingestion::Commands::CancelAdmission.call(msg)
      }.not_to change(Renalware::Admissions::Admission, :count)

      expect(other_admission.reload).to be_present
    end
  end

  context "when the patient does not exist in Renalware" do
    it "does not create or delete anything" do
      msg = hl7_message_from_raw_string(raw_hl7)

      expect {
        Renalware::Admissions::Ingestion::Commands::CancelAdmission.call(msg)
      }.not_to change(Renalware::Admissions::Admission, :count)
    end
  end
end
