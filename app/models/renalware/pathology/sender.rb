module Renalware
  module Pathology
    class Sender < ApplicationRecord
      has_many :obx_mappings, class_name: "Pathology::OBXMapping", dependent: :destroy
      validates :sending_facility, presence: true

      # Attempt to find a sender row in this order
      # 1. Look for a match by sending_facility and sending_application
      # 2. If no match look for sending_facility and sending_application = "*"
      # 3. If not found, create a new sender with facility and application ="*"
      # If app-specific obx mappings are required, someone can manually tweak the senders table
      def self.resolve!(sending_facility:, sending_application:)
        sender = select(
          "distinct on (pathology_senders.sending_facility) pathology_senders.*"
        ).where(
          "? similar to sending_facility and " \
          "(sending_application = ? or sending_application = '*')",
          sending_facility,
          sending_application
        )
          .order(:sending_facility, sending_application: :desc) # desc here allows * to come last
          .first

        sender || create!(sending_facility: sending_facility) # application defaults to *
      end

      def to_s
        [
          sending_facility,
          sending_application
        ].join("/")
      end
    end
  end
end
