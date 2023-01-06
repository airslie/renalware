# frozen_string_literal: true

module Renalware
  module Letters
    class Letter::Completed < Letter
      def self.policy_class
        CompletedLetterPolicy
      end
    end
  end
end
