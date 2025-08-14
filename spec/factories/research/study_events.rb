FactoryBot.define do
  factory :research_study_event, class: "Renalware::Research::StudyEvent" do
    accountable
    patient
    event_type factory: :research_study_event_type
    date_time { Time.current }
    notes { "Some notes" }
    subtype factory: :event_subtype
  end
end
