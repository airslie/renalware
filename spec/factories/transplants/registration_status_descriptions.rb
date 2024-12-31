FactoryBot.define do
  factory :transplant_registration_status_description,
          class: "Renalware::Transplants::RegistrationStatusDescription" do
    code { "active" }
    name { "Active" }

    trait :active do
      code { "active" }
      name { "Active" }
    end
  end
end
