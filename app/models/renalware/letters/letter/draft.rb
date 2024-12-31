module Renalware
  module Letters
    class Letter::Draft < Letter
      def self.policy_class = DraftLetterPolicy

      def revise(params)
        params = LetterParamsProcessor.new(patient).call(params)
        self.attributes = params
      end

      def submit(by:)
        becomes!(PendingReview).tap do |letter|
          letter.by = by
          letter.submitted_for_approval_by = by
          letter.submitted_for_approval_at = Time.current
        end
      end
    end
  end
end
