module Renalware
  module Events
    # A wrapper around the creation of an Event to allow is to broadcast a Wisper event to the
    # 'world' (or rather just whoever has been configured in the broadcast subscription map).
    class CreateEvent
      include Broadcasting

      pattr_initialize [:event!, :by!]

      # Returns the boolean result of event.save_by
      def self.call(**)
        new(**)
          .broadcasting_to_configured_subscribers
          .call
      end

      def call
        event.save_by(by).tap do |success|
          if success
            queue_event_for_document_repository_export
            broadcast(:event_created, event)
          end
        end
      end

      private

      def queue_event_for_document_repository_export
        return unless exportable?(event)

        Renalware::Feeds::QueueForDocumentRepositoryExport.call(
          renderable: event,
          by: event.created_by
        )
      end

      def exportable?(event) = event.event_type&.save_pdf_to_electronic_public_register?
    end
  end
end
