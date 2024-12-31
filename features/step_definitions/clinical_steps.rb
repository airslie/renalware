Given("Patty has these allergies") do |table|
  seed_allergies_for(patient: @patty, user: @clyde || @doug, allergies: table.hashes)
end

When("Clyde views add the following allergies to Patty") do |table|
  create_allergies_for(patient: @patty, user: @clyde, allergies: table.hashes)
end

When(/^Clyde removes the "([^"]*)" allergy$/) do |allergy_description|
  remove_allergy_from_patient(patient: @patty,
                              allergy_description: allergy_description,
                              user: @clyde)
end

Then("Patty has the following allergies") do |table|
  expect_allergies_to_be(expected_allergies: table.hashes, patient: @patty)
end

Then("Patty has these archived allergies") do |table|
  expect_archived_allergies_to_be(expected_allergies: table.hashes, patient: @patty)
end

Then("Clyde is able to mark Patty as having No Known Allergies") do
  mark_patient_as_having_no_allergies(patient: @patty, user: @clyde)
end

When("Donna reviews Patty's clinical summary") do
  @clinical_summary = review_clinical_summary(patient: @patty, user: @donna)
end

Then("Donna should see these current prescriptions in the clinical summary") do |table|
  actual_prescriptions = Renalware::Medications::SummaryPart.new(
    @patty, @clyde
  ).current_prescriptions
  expected_prescriptions = table.hashes

  expect(actual_prescriptions.size).to eq(expected_prescriptions.size)
  actual_prescriptions.zip(expected_prescriptions).each do |actual, expected|
    prescription = Renalware::Medications::PrescriptionPresenter.new(actual)
    expect(actual.drug_name).to eq(expected["drug_name"])
    expect(prescription.dose).to eq(expected["dose"])
    expect(actual.frequency).to eq(expected["frequency"])
    expect(actual.medication_route.name).to eq(expected["route_name"])
    expect(actual.provider.downcase).to eq(expected["provider"].downcase)
    parsed_date = expected["terminated_on"].present? ? Date.parse(expected["terminated_on"]) : nil
    expect(actual.terminated_on).to eq(parsed_date)
  end
end

Then("Donna should see these current problems in the clinical summary:") do |table|
  expect_problems_to_match_table(
    Renalware::Problems::SummaryComponent.new(patient: @patty, current_user: @clyde).problems,
    table
  )
end
