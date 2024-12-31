require "after_commit_everywhere"

module Renalware
  module Letters
    class ApproveLetter
      include Broadcasting
      include AfterCommitEverywhere
      pattr_initialize :letter

      class << self
        alias build new
      end

      def call(by:)
        Letter.transaction do
          add_missing_counterpart_cc_recipients
          archive_recipients
          sign(by: by)
          store_page_count
          archive_content(by: by)
          set_gp_send_status
          # before_letter_approved event
          # - lets listeners clobber the txn by raising an error
          # - lets listeners make other db changes inside the txn eg create a active job
          # letter_approved event
          # - allows post-approval non-transactional processing eg copying a file
          # rollback_letter_approved event
          # - allows listener to undo any non-transactional actions it has taken eg remove a file
          broadcast(:before_letter_approved, base_letter)
          after_commit { broadcast(:letter_approved, base_letter) }
          after_rollback { broadcast(:rollback_letter_approved, base_letter) }
        end
      end

      private

      def base_letter = letter.becomes(Letters::Letter)

      def sign(by:)
        # Needs to be saved before changing the STI type (signature would be lost otherwise)
        letter.sign(by: by).save!
      end

      # Note that generate_archive returns the letter as a Letter::Approved object.
      # We need to update our letter reference as it's this Approved letter we need to broadcast
      # to subscribers.
      def archive_content(by:)
        @letter = letter.generate_archive(by: by)
        letter.save!
      end

      def archive_recipients
        letter.archive_recipients!
      end

      def add_missing_counterpart_cc_recipients
        DetermineCounterpartCCs.new(letter).call.each do |recipient|
          already_a_recipient = letter.recipients.exists?(addressee: recipient.addressee)
          unless already_a_recipient
            recipient.save!
          end
        end
      end

      def store_page_count
        return unless Renalware.config.letters_render_pdfs_with_prawn

        letter_presenter = LetterPresenterFactory.new(letter)
        letter.page_count = Formats::Pdf::Document.new(letter_presenter, nil).build.page_count
      end

      def set_gp_send_status
        letter.gp_send_status = letter.gp_is_a_recipient? ? :pending : :not_applicable
        letter.save!
      end
    end
  end
end
