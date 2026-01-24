# Set ENV var ENABLE_OPENTELEMETRY to "1" to enable opentelemetry.
# Expects there to be bundler group called opentelemetry containing all opentelemetry gems
# (opentelemetry-instrumentation-rails, opentelemetry-instrumentation-pg etc) that we need.
if !Rails.env.test? && ENV.fetch("ENABLE_OPENTELEMETRY", 0).to_i == 1
  Bundler.require(:opentelemetry)

  OpenTelemetry::SDK.configure do |c|
    c.service_name = ENV.fetch("OTEL_SERVICE_NAME", "renalware")
    c.use "OpenTelemetry::Instrumentation::Rack"
    c.use "OpenTelemetry::Instrumentation::Rails"
    c.use "OpenTelemetry::Instrumentation::PG"
    c.use "OpenTelemetry::Instrumentation::ActiveJob"

    # Ensure exporting async and limit memory growth under back-pressure.
    c.add_span_processor(
      OpenTelemetry::SDK::Trace::Export::BatchSpanProcessor.new(
        OpenTelemetry::Exporter::OTLP::Exporter.new,
        schedule_delay: 5_000, # ms
        max_queue_size: 2048,
        max_export_batch_size: 512
      )
    )
    # if defined?(Sentry)
    #   c.add_span_processor(Sentry::OpenTelemetry::SpanProcessor.instance)
    # end
  end
end
