#
# See http://www.hl7.org.uk/repository/uploads/871/1/HL72UKA.3%20v2.pdf
#
describe "HL7 ADT~A28 message handling: 'Add person information'" do
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
      PID|1|#{nhs_number}^^^NHS|#{local_patient_id}^^^KCH||#{family_name}^#{given_name}^#{middle_name}^^#{title}||#{dob}|#{sex}^Female||Not Specified|34 Florence Road^SOUTH CROYDON^Surrey^^CR2 0PP^ZZ993CZ^HOME^QAD||9999999999|5554443333|NSP||NSP|||||Not Specified|.|DNU||8||NSP|#{died_on}|Y
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

  context "when the patient is not in the master index" do
    it "adds them to the master patient index" do
      # See also UpdateMasterPatientIndex
      expect {
        FeedJob.new(message).perform
      }.to change(Renalware::Patients::Abridgement, :count).by(1)
    end
  end

  context "when the patient is already in the master index" do
    it "updates the patient index" do
      # See UpdateMasterPatientIndex
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
