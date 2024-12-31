Given(/^Clyde is logged in$/) do
  login_as @clyde
end

Given(/^Donna is logged in$/) do
  login_as @clyde
end

Given(/^(.*?) is a clinician$/) do |name|
  user = find_or_create_user(given_name: name, role: "clinical")
  instance_variable_set(:"@#{name.downcase}", user)
end

Given(/^(.*?) is a nurse$/) do |name|
  user = find_or_create_user(given_name: name, role: "clinical")
  instance_variable_set(:"@#{name.downcase}", user)
end

Given(/^(.*?) is a doctor/) do |name|
  user = find_or_create_user(given_name: name, role: "clinical")
  instance_variable_set(:"@#{name.downcase}", user)
end

Given("the date today is {date}") do |date|
  travel_to date
end
