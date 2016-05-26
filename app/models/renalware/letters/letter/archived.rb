require_dependency "renalware/letters/letter"

module Renalware
  module Letters
    class Letter::Archived < Letter
      def self.policy_class
        ArchivedLetterPolicy
      end

      def state
        "archived"
      end
    end
  end
end
