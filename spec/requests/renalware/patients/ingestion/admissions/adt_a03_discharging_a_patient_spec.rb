# An A03 event signals the end of a patient's stay in a healthcare facility.
# It signals that the patient's status has changed to "discharged" and that a discharge date
# has been recorded. The patient is no longer in the facility. The patient's location prior
# to discharge should be entered in PV1-3 - Assigned Patient Location.

# rubocop:disable Layout/LineLength
# Example message
#   MSH|^~\&|BLT_TIE|BLT|RENALWARE|MSE|20241105102930||ADT^A03|Q1663235408T1667362075X221298A1117|P|2.4
#   EVN|A03|20241105102900
#   PID|1||10769845^^^RNJ 5C4 MRN^MRN||ZZZTEST^MOM^^^^^CURRENT||19910101|2|||The Royal London Hospital^PO Box 59^^LONDON^E1 1BB^^HOME^^||0777747444^MOBILE~""^HOME~""^EMAIL|""^BUSINESS||""||913401058||||L||||||||N
#   PD1|||ST. STEPHENS HEALTH CENTRE^^F84034|G8901343^BOOMLA^S^^^^^^EXTID
#   PV1|1|I|RNJ RLH 8Z^c Side 6^26^RNJ ROYALLONDON^^BED^RNJ MainBld RLH|22||RNJ RLH 8Z^c Side 6^26^RNJ ROYALLONDON^^BED^RNJ MainBld RLH|C43011451|G8902343||501||||19||||MATERNITY|924301135^^""^^VISITID|||||||||||||||||93768737|19||RNJ ROYALLONDON|||||20241104134800|20241105102900
# rubocop:enable Layout/LineLength
# An A02 event is issued as a result of the patient changing his or her assigned physical location
describe "HL7 ADT^A03 message handling: 'Patient Discharge'" do
  include HL7Helpers
  include PatientsSpecHelper

  let(:visit_number) { "123" }
  let(:system_user) { create(:user, :system) }
  let(:ward)            { "ward" }
  let(:facility)        { "new facility" }
  let(:room)            { "new room" }
  let(:bed)             { "new bed" }
  let(:building)        { "new building" }
  let(:floor)           { "new floor" }
  let(:discharged_at)   { "20241105102900" }
  let(:admitted_at)     { "20241104134800" }
  let(:consultant_family_name)  { "BOOMLA" }
  let(:consultant_initial)      { "S" }
  let(:consultant_code)         { "G8901343" }
  let(:raw_hl7) do
    hl7 = <<-HL7
      MSH|^~\&|BLT_TIE|BLT|RENALWARE|MSE|20241104145144||ADT^A02|Q1663235337T1667362004X221286A1117|P|2.4
      EVN|A02|20241104144000
      PID|1||10769857^^^Dover^MRN||RENALOP2^MOLLY^^^^^CURRENT||19870101|2|||The Royal London Hospital^PO Box 59^^LONDON^E1 1BB^^HOME^^||""^MOBILE~""^HOME~""^EMAIL|""^BUSINESS||S||913401060||||L||||||||N
      PD1|||ST. STEPHENS HEALTH CENTRE^^F84034|G8901343^BOOMLA^S^^^^^^EXTID
      PV1|1|I|#{ward}^#{room}^#{bed}^#{facility}^loc.stat^BED^#{building}^#{floor}^loc.desc|||""^""^""^""^^^""|#{consultant_code}^#{consultant_family_name}^#{consultant_initial}|||424||||79||||NEWBORN|#{visit_number}^^""^^VISITID|||||||||||||||||""|""||RNJ ROYALLONDON|||||#{admitted_at}|#{discharged_at}
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

  def updated_attributes
    {
      bed:,
      room:,
      building:,
      floor:,
      visit_number:,
      consultant_code:,
      consultant: [consultant_initial, consultant_family_name].join(" "),
      admitted_on: Time.zone.parse(admitted_at).to_date,
      discharged_on: Time.zone.parse(discharged_at).to_date
    }
  end

  context "when the patient is not found in Renalware" do
    it "does nothing" do
      msg = hl7_message_from_raw_string(raw_hl7)

      expect {
        Renalware::Admissions::Ingestion::Commands::AdmitPatient.call(msg)
      }.not_to change(Renalware::Admissions::Admission, :count)
    end
  end

  context "when the patient is found in Renalware" do
    context "when they have no admission matching the visit_number" do
      it "creates the admission complete with discharge date" do
        patient = create_patient
        msg = hl7_message_from_raw_string(raw_hl7)

        expect {
          Renalware::Admissions::Ingestion::Commands::AdmitPatient.call(msg)
        }.to change(Renalware::Admissions::Admission, :count).by(1)

        admission = Renalware::Admissions::Admission.last
        expect(admission).to have_attributes(**updated_attributes)
        expect(admission.patient_id).to eq(patient.id)
      end
    end

    context "when they have an existing admission matching the visit_number" do
      it "updates discharge date etc" do
        patient = create_patient
        unit = create(:hospital_unit)
        admission = create(
          :admissions_admission,
          patient:,
          visit_number:,
          hospital_ward: create(:hospital_ward, hospital_unit: unit)
        )
        msg = hl7_message_from_raw_string(raw_hl7)

        expect {
          Renalware::Admissions::Ingestion::Commands::AdmitPatient.call(msg)
        }.not_to change(Renalware::Admissions::Admission, :count)

        admission.reload
        expect(admission).to have_attributes(**updated_attributes)
        expect(admission.patient_id).to eq(patient.id)
      end
    end
  end
end
