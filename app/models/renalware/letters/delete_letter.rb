require "after_commit_everywhere"

module Renalware
  module Letters
    class DeleteLetter
      include Broadcasting
      include AfterCommitEverywhere

      pattr_initialize [:letter!, :by!]

      def self.call(...) = new(...).broadcasting_to_configured_subscribers.call

      def call
        letter_approved? ? soft_delete : hard_delete
      end

      private

      def letter_approved? = letter.approved? || letter.completed?

      def hard_delete
        letter.really_destroy!
      end

      def soft_delete
        Letter.transaction do
          letter.patient.touch
          letter.update!(deleted_by: by, by: by)
          letter.destroy!
          broadcast(:before_letter_deleted, base_letter)
          after_commit { broadcast(:after_letter_deleted, base_letter) }
          after_rollback { broadcast(:rollback_letter_deleted, base_letter) }
        end
      end

      def base_letter = letter.becomes(Letters::Letter)
    end
  end
end
