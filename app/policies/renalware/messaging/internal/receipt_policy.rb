# frozen_string_literal: true

module Renalware
  module Messaging
    module Internal
      class ReceiptPolicy < BasePolicy
        def mark_as_read? = update?
        def unread?       = index?
        def read?         = index?
        def sent?         = index?
      end
    end
  end
end
