FactoryBot.define do
  factory :system_download, class: "Renalware::System::Download" do
    accountable
    name { Faker::File.file_name }
    description { Faker::Lorem.sentence }

    trait :with_file do
      after(:build) do |help|
        help.file.attach(
          io: File.open(Renalware::Engine.root.join("spec", "fixtures", "files", "dog.jpg")),
          filename: "dog.jpg",
          content_type: "image./jpg"
        )
      end
    end
  end
end
