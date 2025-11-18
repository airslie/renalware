FactoryBot.define do
  factory :patient_merge, class: "Renalware::Patients::Merges::Merge" do
    major_patient factory: :patient
    minor_patient factory: :patient
    # feed_message { create(:feed_message) }
    source { "HL7" }
    message_type { "A34" }
    status { "in_progress" }
  end
end
