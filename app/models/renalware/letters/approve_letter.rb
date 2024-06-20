# frozen_string_literal: true

module Renalware
  module Letters
    class ApproveLetter
      include Broadcasting
      pattr_initialize :letter

      class << self
        alias_method :build, :new
      end

      def call(by:)
        Letter.transaction do
          add_missing_counterpart_cc_recipients
          archive_recipients
          sign(by: by)
          store_page_count
          archive_content(by: by)
          # Cast the letter to the base Letter class in case it becomes a Letters::Completed
          # before any async listeners have time to process it.
          broadcast(:letter_approved, letter.becomes(Letters::Letter))
        end
      end

      private

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
    end
  end
end
