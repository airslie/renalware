module Renalware::Feeds
  class MergeEvent < ApplicationRecord
    belongs_to :major_patient, class_name: "Renalware::Patient"
    belongs_to :minor_patient, class_name: "Renalware::Patient"
    belongs_to :feed_message, class_name: "Renalware::Feeds::Message", optional: true

    enum :event_type, {
      A34: "A34",
      A40: "A40",
      manual: "manual"
    }, prefix: true

    enum :status, {
      in_progress: "in_progress",
      completed: "completed",
      failed: "failed"
    }, prefix: true

    enum :source, {
      HL7: "HL7",
      manual: "manual"
    }, prefix: true

    validates :major_patient, :minor_patient, :event_type, :status, presence: true
  end
end
