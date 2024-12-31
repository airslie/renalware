FactoryBot.define do
  factory :feed_file_type, class: "Renalware::Feeds::FileType" do
    name { "PrimaryCarePhysicians" }
    description { "Import GPs" }
    prompt { "Where to get the file etc" }

    trait :primary_care_physicians do
      name { "GPs" }
      description { "Import GPs" }
    end
  end
end
