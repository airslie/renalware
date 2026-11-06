module Renalware
  module Letters
    # The one place that translates "the electronic delivery of the GP's copy of this letter
    # succeeded/failed" into changes to the letter itself. Delivery code (MESH today, Relay
    # later) reports an outcome here and knows nothing about gp_send_status or letter completion.
    #
    # - success: the GP copy no longer needs printing. If the GP was the only recipient there
    #   is nothing left to print, so the letter is completed.
    # - failure: gp_send_status becomes failure, which puts the GP copy in the list of letters
    #   to be printed manually.
    class RecordGPDeliveryOutcome
      include Callable

      OUTCOMES = %i(success failure).freeze

      # Pass either the letter, or just its id. Passing a letter you already have loaded (e.g.
      # via includes) saves a query per call when reconciling a batch.
      def initialize(outcome:, letter: nil, letter_id: nil)
        raise ArgumentError, "Pass a letter or a letter_id" if letter.nil? && letter_id.nil?

        @letter = letter
        @letter_id = letter_id || letter.id
        @outcome = outcome.to_sym
        raise ArgumentError, "Unknown outcome #{outcome.inspect}, expected one of #{OUTCOMES}" \
          unless OUTCOMES.include?(@outcome)
      end

      def call
        send("record_#{outcome}")
      end

      private

      attr_reader :letter_id, :outcome

      def record_success
        letter = @letter || Letter.find(letter_id)
        letter.update_columns(gp_send_status: :success, updated_at: Time.zone.now)
        complete_letter_if_gp_was_only_recipient(letter)
      end

      # update_all avoids loading the letter and leaves updated_at alone (as before).
      def record_failure
        Letter.where(id: letter_id).update_all(gp_send_status: "failure")
      end

      def complete_letter_if_gp_was_only_recipient(letter)
        recipients = letter.recipients
        gp_only = recipients.size == 1 && recipients.first.person_role == :primary_care_physician
        return unless gp_only

        CompleteLetter
          .build(letter)
          .broadcasting_to_configured_subscribers
          .call(by: letter.approved_by)
      end
    end
  end
end
