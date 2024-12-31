# Set ENV var ENABLE_OPENTELEMETRY to "1" to enable opentelemetry.
# Expects there to be bundler group called opentelemetry containing all opentelemetry gems
# (opentelemetry-instrumentation-rails, opentelemetry-instrumentation-pg etc) that we need.
if !Rails.env.test? && ENV.fetch("ENABLE_OPENTELEMETRY", 0).to_i == 1
  Bundler.require(:opentelemetry)

  OpenTelemetry::SDK.configure do |c|
    c.service_name = "Renalware Demo"
    c.use_all # enables all instrumentation!
    # if defined?(Sentry)
    #   c.add_span_processor(Sentry::OpenTelemetry::SpanProcessor.instance)
    # end
  end
end
