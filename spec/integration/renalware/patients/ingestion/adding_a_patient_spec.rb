# frozen_string_literal: true

require "rails_helper"

describe "Update patient information on receipt of an ADT~A31 HL7 message" do
  let(:local_patient_id) { "P123" }
  let(:family_name) { "SMITH" }
  let(:given_name) { "John" }
  let(:middle_name) { "Middling" }
  let(:title) { "Sir" }
  let(:dob) { "19720822000000" }
  let(:died_on) { "20150122154801" }
  let(:sex) { "F" }
  let(:nhs_number) { "1234567890" }
  let(:gp_code) { "G1234567" }
  let(:practice_code) { "P123456" }
  let(:practice) { create(:practice, code: practice_code) }
  let(:primary_care_physician) { create(:primary_care_physician, code: gp_code) }
  let(:system_user) { create(:user, username: Renalware::SystemUser.username) }
  let(:message) do
    hl7 = <<-HL7
      MSH|^~\&|iPM|iIE|TIE|TIE|20110415094635||ADT^A28|558267|P|2.4|||AL|NE
      EVN|A28|20110415094635
      PID|1|#{nhs_number}|#{local_patient_id}||#{family_name}^#{given_name}^#{middle_name}^^#{title}||#{dob}|#{sex}||Not Specified|34 Florence Road^SOUTH CROYDON^Surrey^^CR2 0PP^ZZ993CZ^HOME^QAD||0123456789|5554443333|NSP||NSP|||||Not Specified|.|DNU||8||NSP|#{died_on}|Y
      PD1|||DR WHM SUMISU PRACTICE, Nowhere Surgery, 22 Raccoon Road, Erewhon, Erewhonshire^GPPRC^#{practice_code}|#{gp_code}^Deeley^DP^^^DR
      NK1|1|NOKONE^TESTING^^^MRS|NSP|EREWHON HOSPITAL N H S TR^LEWSEY ROAD^EREWHON^^ER9 0DZ^ZZ993CZ^HOME|01582 111111|01582 333333|NOK^Next of Kin|20110415|||||||F|19600406000000
      PV1|1|R
      Z01|07921 222222|07921 222222|||N|Nowhere Surgery^22 Raccoon Road^Erewhon^Erewhonshire^ER9 9QZ^01582 572817
    HL7
    hl7.gsub(/^[ ]*/, "")
  end

  before do
    primary_care_physician
    practice
    system_user
  end

  context "when the patient exists in Renalware" do
    it "updates their information" do
      patient = create(:patient, local_patient_id: local_patient_id)

      FeedJob.new(message).perform

      verify_patient_properties(patient.reload)
    end
  end

  context "when the patient does not exists in Renalware" do
    it "creates a new patient" do
      FeedJob.new(message).perform

      verify_patient_properties(Renalware::Patient.first)
    end
  end

  # rubocop:disable Metrics/AbcSize
  def verify_patient_properties(patient)
    expect(patient).to have_attributes(
      family_name: family_name,
      given_name: given_name,
      title: title,
      born_on: Time.zone.parse(dob).to_date,
      died_on: Time.zone.parse(died_on).to_date,
      nhs_number: nhs_number,
      primary_care_physician: primary_care_physician,
      practice: practice
    )
    expect(patient.sex.code).to eq(sex)
  end
  # rubocop:enable Metrics/AbcSize
end
