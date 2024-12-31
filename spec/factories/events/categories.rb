FactoryBot.define do
  factory :event_category, class: "Renalware::Events::Category" do
    initialize_with { Renalware::Events::Category.find_or_create_by(name: name) }
    name { "General" }
  end
end
