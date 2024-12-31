module Renalware
  module Messaging
    module Internal
      class Recipient < Renalware::User
        # rubocop:disable Rails/RedundantForeignKey
        has_many :receipts, dependent: :destroy, foreign_key: :recipient_id
        # rubocop:enable Rails/RedundantForeignKey
        has_many :messages, through: :receipts

        def self.model_name = ActiveModel::Name.new(self, nil, "User")
      end
    end
  end
end
