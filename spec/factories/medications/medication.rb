FactoryGirl.define do
  factory :medication, class: "Renalware::Medication" do |medication|
    patient
    drug
    dose "20mg"
    medication_route
    frequency "daily"
    notes "with food"
    provider 0
    prescribed_on 2.weeks.ago
    association :created_by, factory: :user
    association :updated_by, factory: :user

    before(:create) { |medication| medication.treatable ||= medication.patient }

    trait :terminated do
      terminated_on 1.week.ago
    end
  end
end
