FactoryBot.define do
  sequence(:measurement_unit) { |n| "10(#{n})/L" }
  factory :pathology_measurement_unit,
          class: "Renalware::Pathology::MeasurementUnit" do
    name { generate(:measurement_unit) }
    description { "" }
  end
end
