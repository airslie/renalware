Given(/^the following users:$/) do |table|
  table.raw.flatten.each do |users_name|
    given_name, family_name = users_name.split(" ")

    Renalware::User.create!(
      family_name: family_name,
      given_name: given_name,
      email: "#{given_name}.#{family_name}@renalware.net",
      username: "#{given_name}_#{family_name}",
      approved: true,
      password: "supersecret"
    )
  end
end
