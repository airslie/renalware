# frozen_string_literal: true

module Renalware
  module Letters::Transports::Mesh
    class Transmission < ApplicationRecord
      include RansackAll
      belongs_to :letter, class_name: "Letters::Letter"
      has_many :operations, -> { order(created_at: :asc) }, dependent: :destroy
      has_many :download_message_operations,
               -> { where(action: :download_message) },
               dependent: :destroy,
               class_name: "Operation"
      has_many :send_message_operation,
               -> { where(action: :send_message) },
               dependent: :destroy,
               class_name: "Operation"
      has_one :bus_response_operation,
              -> { where(action: :download_message, itk3_response_type: :bus) },
              dependent: :destroy,
              class_name: "Operation"
      has_one :inf_response_operation,
              -> { where(action: :download_message, itk3_response_type: :inf) },
              dependent: :destroy,
              class_name: "Operation"
      validates :letter, presence: true

      enum :status, {
        pending: "pending",
        success: "success",
        failure: "failure"
      }, prefix: true

      # You can cancel an operation if its status is pending and it has no operations
      scope :cancellable, -> { where(status: :pending).where.missing(:operations) }

      def self.policy_class
        BasePolicy
      end

      def self.cancel_pending(letter:)
        return if letter.blank?

        cancellable
          .where(letter_id: letter.id)
          .update_all(status: :cancelled, cancelled_at: Time.zone.now)
      end

      def successful_inf_and_bus_responses?
        [
          operations.to_a.detect { |op| op.success? && op.itk3_infrastructure_response? },
          operations.to_a.detect { |op| op.success? && op.itk3_business_response? }
        ].compact.length == 2
      end

      ransacker :created_at, type: :date do
        Arel.sql("date(created_at)")
      end
    end
  end
end
