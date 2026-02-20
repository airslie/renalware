# An A02 event is issued as a result of the patient changing his or her assigned physical location
#
# rubocop:disable Layout/LineLength
# Example message
#   MSH|^~\&|BLT_TIE|BLT|RENALWARE|MSE|20241104155046||ADT^A02|Q1663235337T1667362004X221286A1117|P|2.4
#   EVN|A02|20241104155000
#   PID|1||10769845^^^RNJ 5C4 MRN^MRN||ZZZTEST^MOM^^^^^CURRENT||19910101|2|||The Royal London Hospital^PO Box 59^^LONDON^E1 1BB^^HOME^^||0777747444^MOBILE~""^HOME~""^EMAIL|""^BUSINESS||""||913401058||||L||||||||N
#   PD1|||ST. STEPHENS HEALTH CENTRE^^F84034|G8901343^BOOMLA^S^^^^^^EXTID
#   PV1|1|I|RNJ RLH 6Z^a Side 28^28^RNJ ROYALLONDON^^BED^RNJ MainBld RLH|22||RNJ RLH 6F^a Side 28^28^RNJ ROYALLONDON^^BED^RNJ MainBld RLH|Z4301145|G8901343||501||||19||||INPATIENT|924301135^^""^^VISITID|||||||||||||||||""|""||RNJ ROYALLONDON|||||20241104134800|
# rubocop:enable Layout/LineLength
describe "HL7 ADT^A02 message handling: 'Patient Transfer'" do
  include HL7Helpers
  include PatientsSpecHelper

  let(:visit_number)  { "123" }
  let(:system_user)   { create(:user, :system) }
  let(:facility)      { "new facility" }
  let(:ward)          { "new ward" }
  let(:room)          { "new room" }
  let(:bed)           { "new bed" }
  let(:building)      { "new building" }
  let(:floor)         { "new floor" }
  let(:consultant_family_name) { "BOOMLA" }
  let(:consultant_initial) { "S" }
  let(:consultant_code) { "G8901343" }
  let(:hospital_service) { "RENAL" }
  let(:raw_hl7) do
    hl7 = <<-HL7
      MSH|^~\&|BLT_TIE|BLT|RENALWARE|MSE|20241104145144||ADT^A02|Q1663235337T1667362004X221286A1117|P|2.4
      EVN|A02|20241104144000
      PID|1||10769857^^^Dover^MRN||RENALOP2^MOLLY^^^^^CURRENT||19870101|2|||The Royal London Hospital^PO Box 59^^LONDON^E1 1BB^^HOME^^||""^MOBILE~""^HOME~x@y.com^EMAIL|""^BUSINESS||S||913401060||||L||||||||N
      PD1|||ST. STEPHENS HEALTH CENTRE^^F84034|G8901343^BOOMLA^S^^^^^^EXTID
      PV1|1|I|#{ward}^#{room}^#{bed}^#{facility}^loc.stat^BED^#{building}^#{floor}^loc.desc|||""^""^""^""^^^""|#{consultant_code}^#{consultant_family_name}^#{consultant_initial}|||#{hospital_service}||||79||||NEWBORN|#{visit_number}^^""^^VISITID|||||||||||||||||""|""||RNJ ROYALLONDON|||||20241104144000|
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

  def verify_admission(admission)
    expect(admission).to have_attributes(
      updated_by: system_user,
      created_by: system_user,
      visit_number:,
      consultant_code:,
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
    award = admission.hospital_ward
    expect(award).to have_attributes(code: ward, name: ward)

    # it created the unit JIT
    expect(award.hospital_unit).to have_attributes(
      unit_code: facility,
      name: facility,
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

  context "when the patient is found in Renalware" do
    context "when they have no admission matching the visit_number" do
      it "creates the admission" do
        create_patient
        msg = hl7_message_from_raw_string(raw_hl7)

        expect {
          Renalware::Admissions::Ingestion::Commands::AdmitPatient.call(msg)
        }.to change(Renalware::Admissions::Admission, :count).by(1)

        admission = Renalware::Admissions::Admission.last
        expect(admission).to have_attributes(visit_number:)
      end
    end

    context "when they have an existing admission matching the visit_number" do
      it "updates the admission" do
        patient = create_patient
        unit = create(:hospital_unit, unit_code: "old facility", name: "old facility")
        ward = create(:hospital_ward, code: "old ward", hospital_unit: unit)
        admission = create(
          :admissions_admission,
          patient:,
          visit_number:,
          hospital_ward: ward,
          consultant: "Dr C",
          consultant_code: "123",
          room: "old room",
          bed: "old bed",
          building: "old building",
          floor: "old floor"
        )
        msg = hl7_message_from_raw_string(raw_hl7)

        expect {
          Renalware::Admissions::Ingestion::Commands::AdmitPatient.call(msg)
        }.not_to change(Renalware::Admissions::Admission, :count)

        admission.reload
        expect(admission).to have_attributes(
          patient_id: patient.id,
          bed:,
          room:,
          building:,
          floor:,
          visit_number:,
          consultant_code:,
          consultant: [consultant_initial, consultant_family_name].join(" ")
        )
        expect(admission.hospital_ward.code).to eq("new ward")
        expect(admission.hospital_ward.hospital_unit.unit_code).to eq("new facility")
      end
    end
  end
end
