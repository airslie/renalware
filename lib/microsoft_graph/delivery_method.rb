# frozen_string_literal: true

require "microsoft_graph/client"

module MicrosoftGraph
  # Uses the MS Graph API to send an email from a specific configured email address.
  # See MicrosoftGraph::Client for API and OAuth2 implementation.
  # Useful when an NHS Trust has disabled SMTP on a renalware NHSMail mailbox.
  class DeliveryMethod
    attr_accessor :settings

    def initialize(delivery_options)
      @settings = delivery_options
    end

    # Note this a straightforward send with no opportunity to invoke before and after hooks
    # defined in delivery_options eg
    #   hook = delivery_options[:before_send] # or :after_send
    #   hook.call(mail, message) if hook.respond_to?(:call)
    # Supporting these would require us to first create a message in Drafts using the API,
    # then handle the before_send hook if there is one, send the Draft message, and then handle
    # any after_send hook. OTT to support unless required.
    # re attachments - these are passed down to the client and handled there.
    # Note that if there is an attachment and mime is text then the mimepart will be
    # included in the body of the email as a text part, not an attachment if you call
    # mail.body.encoded - so we don't do that!
    def deliver!(mail)
      html = mail.mime_type&.downcase&.include?("html")
      graph_client.send_mail(
        from: Renalware.config.mail_oauth_email_address,
        to: mail.to,
        subject: mail.subject,
        body: html ? mail.body.encoded : mail.text_part.body.to_s,
        attachments: mail.attachments,
        html: html
      )
    end

    def graph_client
      @graph_client ||= Client.new(
        tenant_id: Renalware.config.mail_oauth_tenant_id,
        client_id: Renalware.config.mail_oauth_client_id,
        client_secret: Renalware.config.mail_oauth_client_secret
      )
    end
  end
end
