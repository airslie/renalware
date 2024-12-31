FactoryBot.define do
  factory :allergy, class: "Renalware::Clinical::Allergy" do
    patient
    description { Faker::Lorem.sentence }
    recorded_at { Time.zone.now }
  end
end
