FactoryBot.define do
  factory :drug, class: "Renalware::Drugs::Drug" do
    name { "Blue Pill" }

    trait :immunosuppressant do
      after(:create) do |instance|
        instance.drug_types << create(:drug_type, :immunosuppressant)
      end
    end

    trait :esa do
      after(:create) do |instance|
        instance.drug_types << create(:drug_type, :esa)
      end
    end
  end
end
