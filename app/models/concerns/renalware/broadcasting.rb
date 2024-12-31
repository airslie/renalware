module Renalware
  module Broadcasting
    include Wisper::Publisher
    extend ActiveSupport::Concern

    class Subscriber
      attr_reader :klass_name, :async
      alias async? async

      def initialize(klass_name, async: false)
        @klass_name = klass_name
        @async = async
      end

      # Note that when using the wisper-activejob gem
      # we subscribe the class not an instance, and the subscriber must have class
      # methods matching the event names it wants to handle.
      # https://github.com/krisleech/wisper-activejob
      def instance
        async? ? klass : klass.new
      end

      def klass
        klass_name.to_s.constantize
      end
    end

    # Subscribes any listeners configured in Renalware.config.broadcast_subscription_map
    # to the current instance.
    #
    # Example usage
    #
    #   class SomeServiceObject
    #     include Broadcasting
    #
    #     def call
    #       ..
    #     end
    #   end
    #
    #   SomeServiceObject.new(..).broadcasting_to_configured_subscribers.call(..)
    #
    # See https://github.com/krisleech/wisper
    #
    def broadcasting_to_configured_subscribers
      subscribers = Array(Renalware.config.broadcast_subscription_map[self.class.name])
      subscribers.each do |subscriber|
        # Support String subscribers eg a simple class name as well as Subscriber instances.
        subscriber = Subscriber.new(subscriber) unless subscriber.respond_to?(:klass)
        subscribe(subscriber.instance, async: subscriber.async?)
      end
      self
    end
  end
end
