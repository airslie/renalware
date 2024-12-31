module Renalware
  module Messaging
    class UnreadMessagesComponent < ApplicationComponent
      attr_reader :current_user

      def initialize(current_user:)
        @current_user = Messaging::Internal.cast_recipient(current_user)
        super
      end

      def unread_message_receipts
        @unread_message_receipts ||= begin
          receipts = current_user
            .receipts
            .includes(message: [:author, :patient])
            .order("messaging_messages.sent_at asc")
            .unread
          CollectionPresenter.new(receipts, Messaging::Internal::ReceiptPresenter)
        end
      end
    end
  end
end
