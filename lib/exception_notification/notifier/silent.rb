module ExceptionNotification
  class Notifier::Silent < Notifier
    def notify(exception)
      raise MissingBacktrace if exception.backtrace.nil?

      # noop
    end
  end
end
