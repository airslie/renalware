module Renalware
  log "Adding People"

  user = User.first

  50.times do
    given_name = Faker::Name.first_name
    family_name = Faker::Name.last_name
    title = [true, false].sample ? Faker::Name.prefix : nil

    organisation_name = [true, false].sample ? Faker::Company.name : nil

    Directory::Person.create!(
      title: title,
      given_name: given_name,
      family_name: family_name,
      address_attributes: {
        name: "#{title} #{given_name} #{family_name}",
        organisation_name: organisation_name,
        street_1: Faker::Address.street_address,
        city: Faker::Address.city,
        county: Faker::Address.state,
        postcode: Faker::Address.postcode,
        country: "United Kingdom"
      },
      by: user
    )
  end
end
