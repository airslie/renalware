# frozen_string_literal: true

module Renalware
  module Letters
    class ElectronicReceiptPolicy < BasePolicy
      def mark_as_read?
        !record.read? && (record.letter.approved? || record.letter.completed?)
      end

      def unread?
        index?
      end

      def read?
        index?
      end

      def sent?
        index?
      end
    end
  end
end
