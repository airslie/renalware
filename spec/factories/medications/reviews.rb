FactoryBot.define do
  factory :medication_review, class: "Renalware::Medications::Review" do
    accountable
    patient
    date_time { Time.zone.now }
    event_type factory: :medication_review_event_type
  end
end
