# An A01 event is intended to be used for "Admitted" patients only. An A01 event is sent as a
# result of a patient undergoing the admission process which assigns the patient to a bed.
# It signals the beginning of a patient's stay in a healthcare facility. Normally,
# this information is entered in the primary Patient Administration system and broadcast to
# the nursing units and ancillary systems. It includes short stay and "Adam Everyman"
# (e.g., patient name is unknown) admissions.

# rubocop:disable Layout/LineLength
# Example message
#   MSH|^~\&|BLT_TIE|BLT|RENALWARE|MSE|20241104145144||ADT^A01|Q1663235323T1667361990X221284A1117|P|2.4
#   EVN|A01|20241104144000
#   PID|1||10769848^^^RNJ 5C4 MRN^MRN||ZZZTEST^TWIN 2MOM^^^^^CURRENT||20241104144000|2|||The Royal London Hospital^PO Box 59^^LONDON^E1 1BB^^HOME^^||""^MOBILE~""^HOME~""^EMAIL|""^BUSINESS||S||913401060||||L||||||||N
#   PD1|||ST. STEPHENS HEALTH CENTRE^^F84034|G8901343^BOOMLA^S^^^^^^EXTID
#   PV1|1|I|RNJ RLH 6Z^a Side 28^28cb^RNJ ROYALLONDON^^BED^RNJ MainBld RLH|82||""^""^""^""^^^""|Z2736330|||424||||79||||NEWBORN|124301137^^""^^VISITID|||||||||||||||||""|""||RNJ ROYALLONDON|||||20241104144000|
# rubocop:enable Layout/LineLength
describe "HL7 ADT^A01 message handling: 'Inpatient admission'" do
  include HL7Helpers
  include PatientsSpecHelper

  let(:visit_number) { "123" }
  let(:system_user) { create(:user, :system) }
  let(:unit) { "facility" }
  let(:ward) { "ward" }
  let(:room) { "room" }
  let(:bed) { "bed" }
  let(:building) { "building" }
  let(:floor) { "floor" }
  let(:consultant_family_name) { "BOOMLA" }
  let(:consultant_initial) { "S" }
  let(:consultant_code) { "G8901343" }
  let(:hospital_service) { "RENAL" }

  let(:raw_hl7) do
    hl7 = <<-HL7
      MSH|^~\&|BLT_TIE|BLT|RENALWARE|MSE|20241104145144||ADT^A01|Q1663235323T1667361990X221284A1117|P|2.4
      EVN|A01|20241104144000
      PID|1||10769857^^^Dover^MRN||RENALOP2^MOLLY^^^^^CURRENT||19870101|2|||The Royal London Hospital^PO Box 59^^LONDON^E1 1BB^^HOME^^||""^MOBILE~""^HOME~x@y.com^EMAIL|""^BUSINESS||S||913401060||||L||||||||N
      PD1|||ST. STEPHENS HEALTH CENTRE^^F84034|G8901343^BOOMLA^S^^^^^^EXTID
      PV1|1|I|#{ward}^#{room}^#{bed}^#{unit}^loc.stat^BED^#{building}^#{floor}^loc.desc|||""^""^""^""^^^""|#{consultant_code}^#{consultant_family_name}^#{consultant_initial}|||#{hospital_service}||||79||||NEWBORN|#{visit_number}^^""^^VISITID|||||||||||||||||""|""||RNJ ROYALLONDON|||||20241104144000|
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
      local_patient_id: "10769857",
      given_name: "MOLLY",
      family_name: "RENALOP2",
      born_on: Date.parse("19870101")
    ).tap do |pat|
      pat.current_address.update!(postcode: "RG7 0JB")
    end
  end

  def verify_patient(patient)
    # Some simple checks to verify the patient was created correctly
    expect(patient).to have_attributes(
      email: "x@y.com",
      born_on: Date.parse("19870101"),
      current_address: have_attributes(postcode: "E1 1BB")
    )
  end

  def verify_admission(admission) # rubocop:disable Metrics/MethodLength
    expect(admission).to have_attributes(
      updated_by: system_user,
      created_by: system_user,
      visit_number:,
      consultant_code:,
      reason_for_admission: "via HL7",
      consultant: [consultant_initial, consultant_family_name].join(" "),
      room:,
      bed:,
      building:,
      floor:
    )
    verify_ward_and_unit(admission)
  end

  def verify_ward_and_unit(admission)
    # it created the ward JIT
    ward = admission.hospital_ward
    expect(ward).to have_attributes(code: "ward", name: "ward")

    # it created the unit JIT
    expect(ward.hospital_unit).to have_attributes(
      unit_code: "facility",
      name: "facility",
      renal_registry_code: "?",
      unit_type: "hospital"
    )
  end

  context "when the patient is not found in Renalware and hospital service != RENAL" do
    let(:hospital_service) { "NOT_RENAL" }

    it "does not create the admission" do
      msg = hl7_message_from_raw_string(raw_hl7)

      expect {
        Renalware::Admissions::Ingestion::Commands::AdmitPatient.call(msg)
      }.not_to change(Renalware::Admissions::Admission, :count)
    end
  end

  context "when the patient is not found in Renalware but hospital service = RENAL" do
    let(:hospital_service) { "RENAL" }

    it "creates the admission" do
      msg = hl7_message_from_raw_string(raw_hl7)

      expect {
        Renalware::Admissions::Ingestion::Commands::AdmitPatient.call(msg)
      }.to change(Renalware::Admissions::Admission, :count).by(1)
        .and change(Renalware::Patient, :count).by(1)

      verify_patient(Renalware::Patient.last)
      verify_admission(Renalware::Admissions::Admission.last)
    end
  end

  context "when patient is found" do
    it "creates the admission, creating the unit and ward JIT if not found" do
      create_patient

      msg = hl7_message_from_raw_string(raw_hl7)

      expect {
        Renalware::Admissions::Ingestion::Commands::AdmitPatient.call(msg)
      }.to change(Renalware::Admissions::Admission, :count).by(1)
        .and not_change(Renalware::Patient, :count)

      verify_admission(Renalware::Admissions::Admission.last)
    end
  end
end
