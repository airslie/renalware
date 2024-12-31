module Renalware
  module Letters
    class PendingReviewLetterPolicy < LetterPolicy
      def update?   = true
      def reject?   = true
      def approve?  = true
    end
  end
end
