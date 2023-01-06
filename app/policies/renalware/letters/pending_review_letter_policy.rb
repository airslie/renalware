# frozen_string_literal: true

module Renalware
  module Letters
    class PendingReviewLetterPolicy < LetterPolicy
      def update?
        true
      end

      def reject?
        true
      end

      def approve?
        true
      end
    end
  end
end
