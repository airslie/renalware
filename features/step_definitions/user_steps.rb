Given("the following users:") do |table|
  table.raw.flatten.each do |users_name|
    given_name, family_name = users_name.split

    create_user(given_name: given_name, family_name: family_name)
  end
end
