class ApplicationJob < ActiveJob::Base
  rescue_from StandardError do |exception|
    span = OpenTelemetry::Trace.current_span

    if span&.recording?
      span.record_exception(exception)
      span.status = OpenTelemetry::Trace::Status.error("job failed")
    end

    raise exception
  end
end
