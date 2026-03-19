# Base mailer for the standalone app shell.
class ApplicationMailer < ActionMailer::Base
  default from: Renalware.config.default_from_email_address
  layout "mailer"

  rescue_from StandardError do |exception|
    Rails.error.report(
      exception,
      handled: false,
      source: "application.action_mailer",
      context: {
        mailer: self.class.name,
        action: action_name
      }
    )

    raise
  end
end
