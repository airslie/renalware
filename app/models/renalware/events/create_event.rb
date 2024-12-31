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
          broadcast(:event_created, event) if success
        end
      end
    end
  end
end
