# frozen_string_literal: true

describe "HL7 ADT^A08 message handling: 'Patient Update Info (for current episode)'" do
  include HL7Helpers
  include PatientsSpecHelper

  # This trigger event is used when any patient information has changed but when no other trigger
  # event has occurred. For example, an A08 event can be used to notify the receiving systems of a
  # change of address or a name change. The A08 event can include information specific to an episode
  # of care, but it can also be used for demographic information only.
  # In the Renalware context, this message is used to update the admission if one exists.

  # rubocop:disable Layout/LineLength
  # Example message
  #   MSH|^~\&|BLT_TIE|BLT|RENALWARE|MSE|20241104150356||ADT^A08|Q1663235330T1667361997X221285A1117|P|2.4
  #   EVN|A08|20241104150350
  #   PID|1||10769847^^^RNJ 5C4 MRN^MRN||ZZZTEST^TWIN 1MOM^^^^^CURRENT||20241104143500|2|||The Royal London Hospital^PO Box 59^^LONDON^E1 1BB^^HOME^^||""^MOBILE~""^HOME~""^EMAIL|""^BUSINESS||S||913401059||||L||||||||N
  #   PD1|||ST. STEPHENS HEALTH CENTRE^^F84034|G8901343^BOOMLA^S^^^^^^EXTID
  #   PV1|1|I|RNJ RLH 6Z^a Side 28^28ca^RNJ ROYALLONDON^^BED^RNJ MainBld RLH|22||RNJ RLH 6F^a Side 28^28ca^RNJ ROYALLONDON^^BED^RNJ MainBld RLH|Z2736330|||424||||79||||NEWBORN|924301136^^""^^VISITID|||||||||||||||||""|""||RNJ ROYALLONDON|||||20241104143500|
  # rubocop:enable Layout/LineLength

  let(:visit_number)    { "123" }
  let(:system_user)     { create(:user, :system) }
  let(:admitted_at)     { "20241104134800" }
  let(:discharged_at)   { "20241105102900" }
  let(:mrn)             { "10769847" }
  let(:family_name)     { "RENALOP2" }
  let(:given_name)      { "MOLLY" }
  let(:dob)             { "19870101" }
  let(:facility)        { "new facility" }
  let(:ward)            { "new ward" }
  let(:room)            { "new room" }
  let(:bed)             { "new bed" }
  let(:building)        { "new building" }
  let(:floor)           { "new floor" }
  let(:consultant_family_name)  { "BOOMLA" }
  let(:consultant_initial)      { "S" }
  let(:consultant_code)         { "G8901343" }
  let(:raw_hl7) do
    hl7 = <<-HL7
      MSH|^~\&|BLT_TIE|BLT|RENALWARE|MSE|20241104145144||ADT^A02|Q1663235337T1667362004X221286A1117|P|2.4
      EVN|A02|20241104144000
      PID|1||#{mrn}^^^Dover^MRN||#{family_name}^#{given_name}^^^^^CURRENT||#{dob}|2|||The Royal London Hospital^PO Box 59^^LONDON^E1 1BB^^HOME^^||""^MOBILE~""^HOME~""^EMAIL|""^BUSINESS||S||913401060||||L||||||||N
      PD1|||ST. STEPHENS HEALTH CENTRE^^F84034|G8901343^BOOMLA^S^^^^^^EXTID
      PV1|1|I|#{ward}^#{room}^#{bed}^#{facility}^loc.stat^BED^#{building}^#{floor}^loc.desc|||""^""^""^""^^^""|#{consultant_code}^#{consultant_family_name}^#{consultant_initial}|||424||||79||||NEWBORN|#{visit_number}^^""^^VISITID|||||||||||||||||""|""||RNJ ROYALLONDON|||||#{admitted_at}|#{discharged_at}
    HL7
    hl7.gsub(/^ */, "")
  end

  def create_patient
    create(
      :patient,
      local_patient_id: mrn,
      given_name:,
      family_name:,
      born_on: Date.parse(dob)
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

  before do
    system_user
    create(:modality_change_type, :default)
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
      it "creates a new admission (just like and A01)" do
        patient = create_patient
        msg = hl7_message_from_raw_string(raw_hl7)

        expect {
          Renalware::Admissions::Ingestion::Commands::AdmitPatient.call(msg)
        }.to change(Renalware::Admissions::Admission, :count).by(1)

        admission = Renalware::Admissions::Admission.last
        expect(admission.patient_id).to eq(patient.id)
        expect(admission).to have_attributes(**updated_attributes)
        expect(admission.hospital_ward.code).to eq("new ward")
        expect(admission.hospital_ward.hospital_unit.unit_code).to eq("new facility")
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
        expect(admission.patient_id).to eq(patient.id)
        expect(admission).to have_attributes(**updated_attributes)
        expect(admission.hospital_ward.code).to eq("new ward")
        expect(admission.hospital_ward.hospital_unit.unit_code).to eq("new facility")
      end
    end
  end
end
