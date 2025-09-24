module Renalware::Patients::Merges
  class Merge < ApplicationRecord
    belongs_to :major_patient, class_name: "Renalware::Patient", touch: true
    belongs_to :minor_patient, class_name: "Renalware::Patient", touch: true
    belongs_to :feed_message, class_name: "Renalware::Feeds::Message", optional: true
    has_many :operations, class_name: "Operation", dependent: :destroy

    enum :message_type, {
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

    validates :major_patient, :minor_patient, :message_type, :status, presence: true
    validate :major_and_minor_patients_are_different

    def failed!(error)
      update!(
        status: :failed,
        failure_message: Renalware::ExceptionFormatter.new(error).to_s
      )
    end

    def completed! = update!(status: :completed)

    private

    def major_and_minor_patients_are_different
      if minor_patient == major_patient
        errors.add(:minor_patient_id, "must be different from major patient")
      end
    end
  end
end
