Then("Patty's draft letter is accessible from Nathalie's dashboard") do
  expect_draft_letter_accessible_from_dashboard(user: @nathalie, patient: @patty)
end

Then("Patty's pending letter is accessible from Doug's dashboard") do
  expect_pending_letter_accessible_from_dashboard(user: @doug, patient: @patty)
end

Then("Patty is accessible from Doug's dashboard") do
  expect_patient_accessible_from_dashboard(user: @doug, patient: @patty)
end
