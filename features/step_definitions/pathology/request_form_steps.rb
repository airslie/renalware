When(/^Clyde generates a request form with the following:$/) do |table|
  @presenter = generate_pathology_request_form(table.rows_hash)
end

Then(/^Clyde sees these details at the top of the form$/) do |table|
  expect_patient_summary_to_match_table(@presenter, @patty.id, table)
end

Then(/^Clyde sees this patient specific test: (.*)$/) do |test_description|
  expect_patient_specific_test(@presenter, test_description)
end

Then(/^Clyde sees no global tests required$/) do
  expect_no_request_descriptions_required(@presenter)
end

Then(/^Clyde sees the request description ([A-Z0-9]+) required$/) do |request_description_code|
  expect_request_description_required(@presenter, request_description_code)
end
