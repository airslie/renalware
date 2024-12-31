module Renalware
  module Letters
    class ElectronicReceiptPolicy < BasePolicy
      def mark_as_read?
        !record.read? && (record.letter.approved? || record.letter.completed?)
      end

      def unread?   = index?
      def read?     = index?
      def sent?     = index?
    end
  end
end
