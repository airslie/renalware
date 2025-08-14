FactoryBot.define do
  factory :feed_file, class: "Renalware::Feeds::File" do
    file_type factory: %i(feed_file_type)
    accountable
    location { "primary_care_physicians/egpcur.zip" }

    trait :primary_care_physicians do
      file_type factory: %i(feed_file_type primary_care_physicians)
    end
  end
end
