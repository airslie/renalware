# Base mailer for the standalone app shell.
class ApplicationMailer < ActionMailer::Base
  default from: Renalware.config.default_from_email_address
  layout "mailer"

  rescue_from Exception do |exception|
    span = OpenTelemetry::Trace.current_span

    if span&.recording?
      span.record_exception(exception)
      span.status = OpenTelemetry::Trace::Status.error("mailer failed")

      # Low-cardinality attributes only
      span.set_attribute("mail.to", Array(message.to).join(", ")) if message&.to
      span.set_attribute("mail.from", Array(message.from).join(", ")) if message&.from
      span.set_attribute("mail.mailer", self.class.name)
      span.set_attribute("mail.action", action_name)
    end

    raise exception
  end
end
