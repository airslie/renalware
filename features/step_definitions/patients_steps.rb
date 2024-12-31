Given(/^Patty is a patient$/) do
  @patty = Renalware::Patient.create!(
    nhs_number: FactoryBot.generate(:nhs_number),
    given_name: "Patty",
    family_name: "ThePatient",
    local_patient_id: "123456",
    sex: "F",
    born_on: Date.new(1961, 12, 25),
    primary_care_physician: primary_care_physician,
    hospital_centre: FactoryBot.create(:hospital_centre),
    current_address_attributes: {
      name: "Patty ThePatient",
      street_1: "1 Main St",
      town: "London"
    },
    by: Renalware::SystemUser.find
  )
end

Given(/^Patty's sex is (\w+)$/) do |sex|
  @patty.sex = sex
  @patty.save!
end

Given(/^Don is a patient$/) do
  @don = Renalware::Patient.create!(
    nhs_number: FactoryBot.generate(:nhs_number),
    given_name: "Don",
    family_name: "TheDonor",
    local_patient_id: "123457",
    sex: "M",
    born_on: Date.new(1989, 1, 1),
    primary_care_physician: primary_care_physician,
    hospital_centre: FactoryBot.create(:hospital_centre),
    by: Renalware::SystemUser.find
  )
  @don.create_current_address(
    street_1: "2 Main St",
    town: "London"
  )
end

Given "Patty has a practice" do
  @patty.create_practice!(
    name: "Practice A",
    code: Time.current.to_i,
    address: FactoryBot.build(:address)
  )
  @patty.save!
end

Given(/^Phylis is Patty's primary care physician$/) do
  @phylis = @patty.create_primary_care_physician!(
    name: "GOOD PJ",
    practitioner_type: "GP",
    address: FactoryBot.build(:address)
  )
  @patty.create_practice!(
    name: "Practice A",
    code: Time.current.to_i,
    address: FactoryBot.build(:address)
  )
  @patty.save!
end

Given(/^Patty is a diabetic (yes|no)$/) do |diabetic|
  if diabetic == "yes"
    @patty.document.diabetes.diagnosis = true
    @patty.save!
  end
end

Given(/^the following patients:$/) do |table|
  table.raw.flatten.each do |given_name|
    Renalware::Patient.create!(
      family_name: "ThePatient",
      given_name: given_name,
      local_patient_id: SecureRandom.uuid,
      sex: "M",
      born_on: Date.new(1989, 1, 1),
      hospital_centre: FactoryBot.create(:hospital_centre),
      by: Renalware::SystemUser.find
    )
  end
end

Then(/^the patient is created with the following attributes:$/) do |table|
  expect_patient_to_be_created(table.rows_hash)
end
