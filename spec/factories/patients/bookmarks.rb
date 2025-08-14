FactoryBot.define do
  factory :patients_bookmark, class: "Renalware::Patients::Bookmark" do
    user factory: :patients_user
    patient
    notes { Faker::Lorem.sentence }
    urgent { true }
  end
end
