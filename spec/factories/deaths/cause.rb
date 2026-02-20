FactoryBot.define do
  factory :cause_of_death, class: "Renalware::Deaths::Cause" do
    initialize_with {
      Renalware::Deaths::Cause.find_or_create_by!(code:) do |cause|
        cause.description = description
      end
    }
    code { "12" }
    description { "Hyperkalaemia" }

    trait :dementia do
      code { "69" }
      description { "Dementia" }
    end

    trait :cachexia do
      code { "64" }
      description { "Cachexia" }
    end
  end
end
