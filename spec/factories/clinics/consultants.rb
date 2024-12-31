FactoryBot.define do
  factory :consultant, class: "Renalware::Clinics::Consultant" do
    initialize_with { Renalware::Clinics::Consultant.find_or_create_by(name: name) }
    name { "name" }
    sequence(:code) { |n| "Code#{n}" }
  end
end
