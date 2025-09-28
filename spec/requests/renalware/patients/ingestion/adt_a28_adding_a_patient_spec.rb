# frozen_string_literal: true

describe "HL7 ADT^A28 message handling: 'Add person information'" do
  # The A28 event can be used to send everything that is known about a person.
  # These events should not replace the use of the
  # - A01 (admit/visit notification)
  # - A03 (discharge/end visit)
  # - A04 (register a patient)
  # - A08 (update patient information), etc., events.
  # They are not intended to be used for notification of real-time Patient Administration events.
  # These events are primarily for demographic data, but optional historical non-demographic data
  # may be sent as well.
  # May be used for backloading patients into RW from another system.
  #
  # Note at KCH and MSE we receive these events for new patients, where as at Barts for instance
  # they are rare, and we rely on ADT^A01 (admissions) and SIU^S12 (appointments).
  let(:local_patient_id) { "P123" }
  let(:family_name) { "SMITH" }
  let(:given_name) { "John" }
  let(:middle_name) { "Middling" }
  let(:title) { "Sir" }
  let(:dob) { "19720822000000" }
  let(:died_on) { "" }
  let(:sex) { "F" }
  let(:nhs_number) { "9999999999" }
  let(:gp_code) { "G1234567" }
  let(:practice_code) { "P123456" }
  let(:practice) { create(:practice, code: practice_code) }
  let(:primary_care_physician) { create(:primary_care_physician, code: gp_code) }
  let(:system_user) { create(:user, username: Renalware::SystemUser.username) }
  let(:message) do
    hl7 = <<-HL7
      MSH|^~\&|iPM|iIE|TIE|TIE|20110415094635||ADT^A28|558267|P|2.4|||AL|NE
      EVN|A28|20110415094635
      PID|1|#{nhs_number}^^^NHS|#{local_patient_id}^^^Dover||#{family_name}^#{given_name}^#{middle_name}^^#{title}||#{dob}|#{sex}^Female||Not Specified|34 Florence Road^SOUTH CROYDON^Surrey^^CR2 0PP^ZZ993CZ^HOME^QAD||9999999999|5554443333|NSP||NSP|||||Not Specified|.|DNU||8||NSP|#{died_on}|Y
      PD1|||DR WHM SUMISU PRACTICE, Nowhere Surgery, 22 Raccoon Road, Erewhon, Erewhonshire^GPPRC^#{practice_code}|#{gp_code}^Deeley^DP^^^DR
      NK1|1|NOKONE^TESTING^^^MRS|NSP|EREWHON HOSPITAL N H S TR^LEWSEY ROAD^EREWHON^^ER9 0DZ^ZZ993CZ^HOME|01582 111111|01582 333333|NOK^Next of Kin|20110415|||||||F|19600406000000
      PV1|1|R
      Z01|07921 222222|07921 222222|||N|Nowhere Surgery^22 Raccoon Road^Erewhon^Erewhonshire^ER9 9QZ^01582 572817
    HL7
    hl7.gsub(/^ */, "")
  end

  before do
    primary_care_physician
    practice
    system_user
  end

  context "when the patient exists in Renalware" do
    it "updates their information" do
      patient = create(:patient, local_patient_id: local_patient_id, born_on: Date.parse(dob))

      expect {
        FeedJob.new(message).perform
      }.not_to change(Renalware::Patient, :count)

      verify_patient_properties(patient.reload)
    end
  end

  context "when the patient does not exist in Renalware" do
    it "does not add them as a Renalware::Patient" do
      expect {
        FeedJob.new(message).perform
      }.not_to change(Renalware::Patient, :count)
    end
  end

  def verify_patient_properties(patient)
    expect(patient).to have_attributes(
      family_name: family_name,
      given_name: given_name,
      title: title,
      born_on: Date.parse(dob),
      nhs_number: nhs_number,
      primary_care_physician: primary_care_physician,
      practice: practice
    )
    expect(patient.sex.code).to eq(sex)
  end
end
