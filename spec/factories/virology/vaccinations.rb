FactoryBot.define do
  factory :vaccination, class: "Renalware::Virology::Vaccination" do
    accountable
    event_type factory: :vaccination_event_type
    document { { type: "code", drug: "The drug" } }
    patient
    date_time { Time.zone.now }
  end
end
