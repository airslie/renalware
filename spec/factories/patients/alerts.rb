FactoryBot.define do
  factory :patient_alert, class: "Renalware::Patients::Alert" do
    accountable
    patient
    notes { Faker::Lorem.sentence }
    urgent { true }
  end
end
