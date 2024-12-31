FactoryBot.define do
  factory :vaccination, class: "Renalware::Virology::Vaccination" do
    event_type factory: :vaccination_event_type
    document { {} }
  end
end
