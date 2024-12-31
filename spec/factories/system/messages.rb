FactoryBot.define do
  factory :system_message, class: "Renalware::System::Message" do
    title { "Test title" }
    body { "Test body" }
    display_from { Time.zone.now }
  end
end
