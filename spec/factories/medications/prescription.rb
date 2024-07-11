# frozen_string_literal: true

# rubocop:disable FactoryBot/AssociationStyle
FactoryBot.define do
  factory :prescription, class: "Renalware::Medications::Prescription" do
    accountable
    patient
    drug
    dose_amount { "20" }
    association :unit_of_measure, :mg, factory: :drug_unit_of_measure
    medication_route
    frequency { "daily" }
    notes { "with food" }
    provider { 0 }
    prescribed_on { 2.weeks.ago }

    after(:build) { |prescription| prescription.treatable ||= prescription.patient }
  end
end
# rubocop:enable FactoryBot/AssociationStyle
