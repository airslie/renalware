FactoryBot.define do
  factory :feed_merge_event, class: "Renalware::Feeds::MergeEvent" do
    major_patient factory: :patient
    minor_patient factory: :patient
    # feed_message { create(:feed_message) }
    source { "HL7" }
    event_type { "A34" }
    status { "in_progress" }
    details { "Merge event details" }
  end
end
