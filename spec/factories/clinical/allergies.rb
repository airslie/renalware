FactoryBot.define do
  factory :allergy, class: "Renalware::Clinical::Allergy" do
    accountable
    patient factory: :clinical_patient
    description { Faker::Lorem.sentence }
    recorded_at { Time.zone.now }
  end
end
