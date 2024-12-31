Given("Phylis is a primary care physician") do
  @phylis = Renalware::Patients::PrimaryCarePhysician.create!(
    name: "PARFIT P",
    telephone: "0203593082",
    code: "123IUY",
    practitioner_type: "GP",
    address: FactoryBot.build(:address)
  )
end

When("Clyde assigns Phylis to Patty as a primary care physician") do
  assign_primary_care_physician_to(@patty, primary_care_physician: @phylis, user: @clyde)
end

Then("Phylis is now Patty's primary care physician") do
  expect_patient_primary_care_physician_to_be(@phylis, patient: @patty)
end
