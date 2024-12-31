Given("Patty has a recorded access profile") do
  seed_access_profile_for(@patty, user: Renalware::User.first)
end

Given("Patty has a recorded access procedure") do
  seed_access_procedure_for(@patty, user: Renalware::User.first)
end

Given("Patty has a recorded access assessment") do
  seed_access_assessment_for(@patty, user: Renalware::User.first)
end

When("Clyde records an access profile for Patty") do
  create_access_profile(patient: @patty, user: @clyde)
end

When("Clyde submits an erroneous access profile") do
  create_access_profile(patient: @patty, user: @clyde, side: nil)
end

When("Clyde records an access procedure for Patty") do
  create_access_procedure(patient: @patty, user: @clyde)
end

When("Clyde submits an erroneous access procedure") do
  create_access_procedure(patient: @patty, user: @clyde, access_type: nil)
end

When("Clyde records an access assessment for Patty") do
  create_access_assessment(patient: @patty, user: @clyde)
end

When("Clyde submits an erroneous access assessment") do
  create_access_assessment(patient: @patty, user: @clyde, access_type: nil)
end

Then("Patty has a new access profile") do
  expect_access_profile_to_exist(@patty)
end

Then("Clyde can update Patty's access profile") do
  update_access_profile(patient: @patty, user: @clyde)
end

Then("the access profile is not accepted") do
  expect_access_profile_to_be_refused
end

Then("Patty has a new access procedure") do
  expect_access_procedure_to_exist(@patty)
end

Then("Clyde can update Patty's access procedure") do
  update_access_procedure(patient: @patty, user: @clyde)
end

Then("the access procedure is not accepted") do
  expect_access_procedure_to_be_refused
end

Then("Patty has a new access assessment") do
  expect_access_assessment_to_exist(@patty)
end

Then("Clyde can update Patty's access assessment") do
  update_access_assessment(patient: @patty, user: @clyde)
end

Then("the access assessment is not accepted") do
  expect_access_assessment_to_be_refused
end
