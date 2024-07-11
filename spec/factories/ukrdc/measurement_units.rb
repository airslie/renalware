# frozen_string_literal: true

FactoryBot.define do
  factory :ukrdc_measurement_unit, class: "Renalware::UKRDC::MeasurementUnit" do
    name { "mg" }
    description { "milligrams" }

    trait :mg do
      name { "mg" }
      description { "milligrams" }
    end
  end
end
