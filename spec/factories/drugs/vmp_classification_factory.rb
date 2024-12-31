FactoryBot.define do
  factory :drug_vmp_classification,
          class: "Renalware::Drugs::VMPClassification" do
    sequence(:code) { |n| "VMP-CODE-#{n}" }
    drug { nil }
    form { nil }
    route { nil }
    unit_of_measure { nil }
  end
end
