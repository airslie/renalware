# frozen_string_literal: true

module Renalware
  module HD
    class SlotRequest < ApplicationRecord
      include Accountable
      include PatientsRansackHelper
      acts_as_paranoid
      belongs_to :patient
      belongs_to :deletion_reason, class_name: "SlotRequestDeletionReason"

      scope :current, -> { where(allocated_at: nil) }
      scope :historical, lambda {
        with_deleted.where.not(deleted_at: nil).or(where.not(allocated_at: nil))
      }
      scope :allocated, -> { where.not(allocated: nil) }

      enum urgency: {
        routine: "routine",
        urgent: "urgent",
        highly_urgent: "highly_urgent"
      }

      has_paper_trail(
        versions: { class_name: "Renalware::HD::Version" },
        on: [:create, :update, :destroy]
      )

      validates :patient_id,
                presence: true,
                uniqueness: {
                  scope: [:deleted_at, :allocated_at],
                  message: "already has an active slot request"
                }
      validates :urgency, presence: true
      validates :deletion_reason, presence: { if: :deleted_at }
      validates :notes, presence: true

      scope :ordered, -> { order(created_at: :desc) }
    end
  end
end
