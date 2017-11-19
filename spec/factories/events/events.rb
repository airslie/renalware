FactoryBot.define do
  factory :event, class: "Renalware::Events::Event" do
    accountable
    patient
    event_type factory: :events_type
    date_time { Time.zone.now }
    description "Needs blood sample taken."
    notes "Would like son to accompany them on clinic visit."

    factory :simple_event, class: "Renalware::Events::Simple" do

    end

    factory :swab, class: "Renalware::Events::Swab" do
      event_type factory: :swab_event_type
      document {
        {
          type: Renalware::Events::Swab::Document.type.values.first,
          result: Renalware::Events::Swab::Document.result.values.first,
          location: "The location"
        }
      }
    end
  end
end
