# frozen_string_literal: true

module Renalware
  module Messaging
    module Internal
      class ReceiptPresenter < SimpleDelegator
        def message
          @message ||= Renalware::Messaging::Internal::MessagePresenter.new(super)
        end
      end
    end
  end
end
