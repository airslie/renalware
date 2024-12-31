# Example host application mailer base class.
# The mailer layout must be present e.g. app/views/layouts/mailer.html.slim
class ApplicationMailer < ActionMailer::Base
  default from: Renalware.config.default_from_email_address
  layout "mailer"
end
