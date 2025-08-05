module Renalware
  module Events
    # A wrapper around the deletion of an Event to allow us to broadcast a Wisper event
    # (configured in the broadcast subscription map) which lets subscribers know the event has been
    # deleted. This is useful for things sending an HL7 messages to let downstream systems know
    # that the event document (a PDF representing some MDM meeting notes for example) should be
    # flagged as deleted.
    class DeleteEvent
      include Broadcasting

      pattr_initialize [:event!]

      def self.call(**)
        new(**)
          .broadcasting_to_configured_subscribers
          .call
      end

      def call
        event.destroy!
        broadcast(:event_deleted, event)
      end
    end
  end
end
