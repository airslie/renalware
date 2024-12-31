FactoryBot.define do
  factory :directory_person, class: "Renalware::Directory::Person" do
    accountable
    given_name   { Faker::Name.first_name }
    family_name  { Faker::Name.last_name }
    title        { Faker::Name.prefix }
  end
end
