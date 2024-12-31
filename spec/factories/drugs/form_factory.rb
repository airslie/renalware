FactoryBot.define do
  factory :drug_form, class: "Renalware::Drugs::Form" do
    sequence(:code) { |n| "Code#{n}" }
  end
end
