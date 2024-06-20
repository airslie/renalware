# frozen_string_literal: true

module Renalware
  module Letters
    class ApprovedLetterPolicy < LetterPolicy
      def complete? = true
    end
  end
end
