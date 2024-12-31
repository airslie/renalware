module Renalware
  module HD
    # Tracks the import of incoming HD Session data from an integrated dialysis provider
    # and the outgoing data back to that provider, for example HL7 messages.
    class TransmissionLog < ApplicationRecord
      include RansackAll
      belongs_to :hd_provider_unit, class_name: "ProviderUnit"
      belongs_to :patient, class_name: "Renalware::Patient"
      belongs_to :session
      validates :direction, presence: true
      validates :format, presence: true
      has_many :children,
               class_name: "TransmissionLog",
               foreign_key: "parent_id",
               dependent: :destroy
      belongs_to :parent, class_name: "TransmissionLog"

      def self.policy_class = BasePolicy
    end
  end
end
