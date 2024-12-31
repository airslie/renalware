FactoryBot.define do
  factory :dmd_actual_medical_product, class: "Renalware::Drugs::DMD::ActualMedicalProduct" do
    sequence(:code) { |n| "Code#{n}" }
  end
end
