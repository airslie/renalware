module Renalware
  module ExceptionNotifier
    class << self
      attr_writer :notifier

      def notifier
        @notifier ||= NullExceptionNotifier.new
      end

      def notify(exception, **)
        notifier.notify(exception, **) if notifier.respond_to?(:notify)
      end
    end
  end
end
