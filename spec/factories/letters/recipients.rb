FactoryBot.define do
  factory :letter_recipient, class: "Renalware::Letters::Recipient" do
    trait :main do
      role { "main" }
      person_role { "patient" }
    end

    trait :cc do
      role { "cc" }
    end
  end
end
