module Renalware
  module Letters
    class QueueForDocumentRepositoryExport
      include Callable

      def initialize(letter:)
        @letter = letter
      end

      def call
        return unless Renalware.config.feeds_outgoing_documents_enabled

        # Create a row in outgoing documents. Mirth will poll the renalware-core api
        # at feeds/outgoing_documents.json to get a list of waiting documents and will then
        # iterate through these and call another api endpoint to render each to an
        # HL7 message with a base64-encoded PDF, and send this HL7 message to the
        # MSE TIE before making a PUT call to update RW to say the message was sent
        # successfully.
        Renalware::Feeds::OutgoingDocument.create!(renderable: letter, by: letter.approved_by)
      end

      private

      attr_reader :letter
    end
  end
end
