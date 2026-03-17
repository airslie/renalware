FactoryBot.define do
  factory :drug_unit_of_measure, class: "Renalware::Drugs::UnitOfMeasure" do
    sequence(:code) { "Code#{it}" }
    initialize_with do
      Renalware::Drugs::UnitOfMeasure.find_or_create_by!(name:, code:)
    end

    name { "mg" }

    trait :mg do
      code { "258684004" }
      name { "mg" }
    end
  end
end
