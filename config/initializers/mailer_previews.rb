# frozen_string_literal: true

# Enable mailer previews in UAT
#
if Rails.env.uat?
  class ::Rails::MailersController
    def local_request?
      true
    end
  end
end
