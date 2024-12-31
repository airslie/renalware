Given(/^Clyde has Patty's renal profile$/) do
  edit_renal_profile(@clyde, @patty)
end

When(/^Clyde submits Patty's ESRF details$/) do
  update_renal_profile(@clyde, @patty)
end

Then(/^Patty's renal profile is updated$/) do
  expect_renal_profile_to_be_updated(@clyde, @patty)
end
