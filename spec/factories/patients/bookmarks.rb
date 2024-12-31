FactoryBot.define do
  factory :patients_bookmark, class: "Renalware::Patients::Bookmark" do
    notes { Faker::Lorem.sentence }
    urgent { true }
  end
end
