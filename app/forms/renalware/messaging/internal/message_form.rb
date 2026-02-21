# A form object used behind the html messages#new form, and serving to helps us capture
# attributes for a Message and its Recipients. The MessageForm is passed to the SendMessage
# object where it is persisted as a Message with many Recipients through Receipts.

module Renalware
  module Messaging
    module Internal
      class MessageForm
        include ActiveModel::Model
        include Virtus::Model

        attribute :body, String
        attribute :subject, String
        attribute :urgent, Boolean, default: false
        attribute :recipient_ids, Array, default: []
        attribute :replying_to_message_id
        attribute :public, Boolean, default: true

        validates :body, presence: true
        validates :subject, presence: true
        validates :recipient_ids, presence: true, length: { minimum: 1 }

        def initialize(attributes = {})
          remove_blank_recipient_ids_from(attributes)
          super
        end

        private

        def remove_blank_recipient_ids_from(params)
          params[:recipient_ids].compact_blank! if params.key?(:recipient_ids)
        end
      end
    end
  end
end
