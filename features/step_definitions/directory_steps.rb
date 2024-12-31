Given("A person exists in the directory") do
  seed_person(user: Renalware::User.first)
end

Given("Sam is a social worker") do
  @sam = seed_person(given_name: "Sam", user: Renalware::User.first)
end

When("Clyde adds a person to the directory") do
  create_person(user: @clyde)
end

When("Clyde adds an erroneous person to the directory") do
  create_person(user: @clyde, attributes: { given_name: nil })
end

Then("the directory includes the person") do
  expect_person_to_exist
end

Then("the person is not accepted") do
  expect_person_to_be_refused
end

Then("Clyde can update the person") do
  update_person(user: @clyde)
end
