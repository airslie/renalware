module Renalware
  module Events
    # A wrapper around the updating of an Event to allow is to broadcast a Wisper event to anyone
    # configure to listen in the broadcast subscription map.
    class UpdateEvent
      include Broadcasting
      pattr_initialize [:event!, :params!, :by!]

      # Returns the boolean result of event.update_by
      def self.call(**)
        new(**)
          .broadcasting_to_configured_subscribers
          .call
      end

      def call
        event.update_by(by, params).tap do |success|
          broadcast(:event_updated, event) if success
        end
      end
    end
  end
end
