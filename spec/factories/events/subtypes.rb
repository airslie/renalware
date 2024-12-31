FactoryBot.define do
  factory :event_subtype, class: "Renalware::Events::Subtype" do
    by factory: %i(user)
    event_type
    name { "Subtype1" }
    description { "SubtypeDesc1" }
    definition { [{ x: "y" }] }
  end
end
