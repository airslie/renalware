Given(/^there are ethnicities in the database$/) do
  @ethnicities = ["White", "Black", "Asian"]
  @ethnicities.map! { |e| Ethnicity.create!(:name => e) }
end

Given(/^I have a patient in the database$/) do
  @patient = Patient.create!(
    :nhs_number => "1000124502",
    :local_patient_id => "Z999999",
    :surname => "RABBIT",
    :forename => "R",
    :dob => "01/01/1947",
    :paediatric_patient_indicator => "1",
    :sex => 1,
    :ethnicity_id => Ethnicity.last.id
    )

end

Given(/^that I'm logged in$/) do
end

Given(/^I've searched for a patient$/) do
end

Given(/^I've selected the patient from the search results$/) do
  visit demographics_patient_path(@patient)
end

Then(/^I should see the patient's demographics on their profile page$/) do
  expect(page.has_content? "1000124502").to be true
  expect(page.has_content? "RABBIT").to be true
  expect(page.has_content? "R").to be true
end