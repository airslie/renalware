FactoryBot.define do
  factory :drug_type, class: "Renalware::Drugs::Type" do
    initialize_with do
      Renalware::Drugs::Type.find_or_create_by!(code: code, name: name)
    end

    code { "immuno" }
    name { "immuno" }

    trait :immunosuppressant do
      code { "immunosuppressant" }
      name { "Immunosuppressant" }
    end

    trait :antibiotic do
      name { "Antibiotic" }
      code { "antibiotic" }
    end

    trait :esa do
      code { "esa" }
      name { "ESA" }
    end
  end
end
