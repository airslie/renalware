FactoryBot.define do
  factory :event_subtype, class: "Renalware::Events::Subtype" do
    by factory: %i(user)
    event_type
    sequence(:name) { "Subtype#{it}" }
    description { "SubtypeDesc1" }
    definition { [{ x: "y" }] }
  end
end
