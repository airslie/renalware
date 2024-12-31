require "pdf/reader"

module Renalware
  module Letters
    # This class is both a Wisper listener (subscribing to ApproveLetter events) and an ActiveJob.
    # Should be configured in the broadcast_subscription_map to listen to events from ApproveLetter
    # and be invoked asynchronously via a activejob.
    #
    # We generate a PDF version of the letter (or retrieve it from the cache) and inspect it
    # using a PDF tool to get the page count. We then save that away to the letters table.
    #
    # The page count is useful when printing letters; letters with the same page count can be
    # printed together and fed into an envelope stuffer with the same page count setting eg 2
    # (address cover sheet + duplex printed letter). Most of the time page count will be 1,
    # but the page count setting on the printer will be 2 because of the additional address cover
    # sheet.
    class CalculatePageCountJob < ApplicationJob
      pattr_initialize :letter

      queue_with_priority 0 # high

      # This method is the name of an event raised elsewhere by a Wisper publisher.
      # It needs to be a class method in order to be invoked asynchronously by activejob
      def self.letter_approved(letter)
        new(letter).call
      end

      def call
        letter.update_column(:page_count, pdf_reader.page_count)
        letter.archive.update_column(:pdf_content, pdf_data) if letter.archive.present?
      rescue StandardError => e
        # In Wisper async jobs, rescue_from blocks defined on the ApplicationJob class
        # do not seem to be called, so we need to invoke them ourselves with this call to a fn on
        # ActiveSupport::Rescuable which is already mixed into ActiveJob::Base.
        rescue_with_handler(e) || raise
      end

      private

      def pdf_reader
        PDF::Reader.new(StringIO.new(pdf_data))
      end

      def pdf_data
        @pdf_data ||= RendererFactory.renderer_for(letter, :pdf).call
      end
    end
  end
end
