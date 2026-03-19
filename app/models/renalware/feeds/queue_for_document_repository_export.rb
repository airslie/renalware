module Renalware
  module Feeds
    class QueueForDocumentRepositoryExport
      def self.call(...)
        new(...).call
      end

      def initialize(renderable:, by:)
        @renderable = renderable
        @by = by
      end

      def call
        return unless Renalware.config.feeds_outgoing_documents_enabled

        # Create a row in outgoing documents. Mirth will poll the renalware-core api
        # at feeds/outgoing_documents.json to get a list of waiting documents and will then
        # iterate through these and call another api endpoint to render each to an
        # HL7 message with a base64-encoded PDF, and send this HL7 message to the
        # MSE TIE before making a PUT call to update RW to say the message was sent
        # successfully.
        OutgoingDocument.create!(renderable:, by:)
      end

      private

      attr_reader :renderable, :by
    end
  end
end
