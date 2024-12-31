module ExceptionNotification
  class Notifier::PartyFoulAdapter < Notifier
    def notify(exception)
      # If not backtrace is present, PartyFoul will raise an exception itself:
      # NoMethodError:
      # undefined method `map' for nil:NilClass
      # party_foul-1.5.5/lib/party_foul/issue_renderers/base.rb:59:in `stack_trace'
      #
      raise MissingBacktrace if exception.backtrace.nil?

      PartyFoul::RacklessExceptionHandler.handle(exception, {})
    end
  end
end
