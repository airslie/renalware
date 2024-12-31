module Renalware
  module Messaging
    class UnreadMessageCountComponent < ApplicationComponent
      include Renalware::UsersHelper
      pattr_initialize [:current_user!]

      def number_of_unread_messages
        @number_of_unread_messages ||= Renalware::Messaging::Internal.cast_recipient(current_user)
          .receipts
          .unread
          .count
      end

      def friendly_number_of_unread_messages
        number_of_unread_messages > 99 ? "99+" : number_of_unread_messages
      end

      def render?
        number_of_unread_messages > 0
      end
    end
  end
end
