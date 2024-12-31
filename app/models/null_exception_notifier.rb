# The host app can supply a handler for logging errors in background jobs, like so
#  Renalware::Engine.exception_notifier = MyExceptionNotifier.new
# where the supplied instance must respond to .notify(exception, **params).
# Where a handler is not supplied we default to using this null handler.
class NullExceptionNotifier
  def notify(exception, **_params)
    # noop
  end
end
