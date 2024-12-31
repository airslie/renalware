module Renalware
  module Letters
    class DraftLetterPolicy < LetterPolicy
      def update? = true
      def submit_for_review? = true
    end
  end
end
