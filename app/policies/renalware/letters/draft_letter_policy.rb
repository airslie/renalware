# frozen_string_literal: true

module Renalware
  module Letters
    class DraftLetterPolicy < LetterPolicy
      def update?
        true
      end

      def submit_for_review?
        true
      end
    end
  end
end
