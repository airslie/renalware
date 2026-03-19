class OpenTelemetryErrorSubscriber
  def report(error, handled:, severity:, context:, source:)
    span = OpenTelemetry::Trace.current_span
    return unless span&.recording?

    span.record_exception(error)
    span.status = OpenTelemetry::Trace::Status.error(error.class.name)
    span.set_attribute("error.source", source)
    span.set_attribute("error.handled", handled)
    span.set_attribute("error.severity", severity.to_s)

    context.each do |key, value|
      next unless otel_attribute_value?(value)

      span.set_attribute("error.context.#{key}", value)
    end
  rescue StandardError
    nil
  end

  private

  def otel_attribute_value?(value)
    case value
    when String, Integer, Float, TrueClass, FalseClass
      true
    when Array
      value.all? { |item| otel_attribute_value?(item) }
    else
      false
    end
  end
end
