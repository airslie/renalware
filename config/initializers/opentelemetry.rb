# Set ENV var ENABLE_OPENTELEMETRY to "1" to enable opentelemetry.
# Expects there to be bundler group called opentelemetry containing all opentelemetry gems
# (opentelemetry-instrumentation-rails, opentelemetry-instrumentation-pg etc) that we need.
if !Rails.env.test? && ENV.fetch("ENABLE_OPENTELEMETRY", 0).to_i == 1
  Bundler.require(:opentelemetry)

  # Use sampling in prod to reduce volume of traces sent to backend.
  # A decent default is 5-20% in prod, 100% in dev.
  # OTEL_TRACES_SAMPLER_ARG is a float between 0.0 and 1.0 representing the fraction of traces to
  # sample. So 0.1 = 10%
  sampler = if Rails.env.local?
              OpenTelemetry::SDK::Trace::Samplers.always_on
            else
              raw = ENV.fetch("OTEL_TRACES_SAMPLER_ARG", "0.1")
              fraction = Float(raw) rescue 0.1 # rubocop:disable Style/RescueModifier
              fraction = fraction.clamp(0.0, 1.0)
              OpenTelemetry::SDK::Trace::Samplers.trace_id_ratio_based(fraction)
            end

  OpenTelemetry::SDK.configure do |c|
    c.service_name = ENV.fetch("OTEL_SERVICE_NAME", "renalware")
    c.sampler = sampler
    c.use "OpenTelemetry::Instrumentation::Rack"
    c.use "OpenTelemetry::Instrumentation::Rails"
    c.use "OpenTelemetry::Instrumentation::PG"

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
