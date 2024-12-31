module Renalware
  module Messaging
    module Internal
      class ReceiptPresenter < SimpleDelegator
        def message
          @message ||= Renalware::Messaging::Internal::MessagePresenter.new(super)
        end

        def also_sent_to
          message.recipients.reject { |user| user.id == current_user.id }
        end

        private

        def current_user
          Renalware::User.find(recipient_id)
        end
      end
    end
  end
end
