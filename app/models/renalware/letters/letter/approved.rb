module Renalware
  module Letters
    class Letter::Approved < Letter
      def self.policy_class = ApprovedLetterPolicy

      def complete(by:)
        becomes!(Completed).tap do |letter|
          letter.by = by
          letter.completed_by = by
          letter.completed_at = Time.current
        end
      end
    end
  end
end
