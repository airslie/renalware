FactoryBot.define do
  sequence :worry_category_name do |idx|
    "Category#{idx}"
  end

  factory :worry_category, class: "Renalware::Patients::WorryCategory" do
    accountable
    name { generate(:worry_category_name) }
  end
end
