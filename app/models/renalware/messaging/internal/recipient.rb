# frozen_string_literal: true

require_dependency "renalware/messaging"

module Renalware
  module Messaging
    module Internal
      class Recipient < ActiveType::Record[Renalware::User]
        has_many :receipts, dependent: :destroy
        has_many :messages, through: :receipts
      end
    end
  end
end
