Given(/^Clinics$/) do |clinics|
  clinics.hashes.each do |clinic_params|
    create_clinic(clinic_params)
  end
end

Given("Patty has a recorded clinic visit") do
  @clinic_visit = create_clinic_visit(@patty, @clyde || Renalware::User.first)
end

Given("the following consultants:") do |table|
  table.raw.flatten.each do |name|
    FactoryBot.create(:consultant, name: name, code: SecureRandom.uuid)
  end
end

When("Clyde records Patty's clinic visit") do
  @clinic_visit = record_clinic_visit(@patty, @clyde)
end

When("Clyde updates Patty's clinic visit") do
  update_clinic_visit(@clinic_visit, @patty, @clyde)
end

Then("Patty's clinic visit should exist") do
  expect_clinic_visit_to_exist(@patty)
end

Then("Patty's clinic visit should be updated") do
  expect_clinic_visit_to_be_updated(@clinic_visit)
end
