# Filters sensitive data from exception messages. In some exception messages, such
# as routing errors, Rails will include the object it attempted to create a route with,
# exposing records from the database. This middleware reporter using PartyFoul filters
# the messages before reporting.
#
module ExceptionNotification
  class Middleware < PartyFoul::Middleware
    def initialize(app)
      @app = app
      super
    end

    # rubocop:disable Lint/RescueException
    def call(env)
      @app.call(env)
    rescue Exception => e
      if allow_handling?(e)
        PartyFoul::ExceptionHandler.handle(FilteredException.new(e), env)
      end
      raise e
    end
    # rubocop:enable Lint/RescueException
  end
end
