require "faraday"

# Client for Microsoft Graph API.
#
# Only supports the Client Credentials OAuth2 flow suitable for conneciton from a daemon
# or server process. We fetch the token on each request rather than fetching once until it needs
# refreshing.
#
# Currently only supports sending an email from a specific account (see MicrosoftGraph::Mailer)
# but can be extended.
#
# Example usage
#   client = Client.new(
#     tenant_id: Renalware.config.mail_oauth_tenant_id,
#     client_id: Renalware.configmail_oauth_client_id,
#     client_secret: Renalware.config.mail_oauth_client_secret
#   )
#   client.send_mail(
#     from: Renalware.config.mail_oauth_email_address,
#     subject: "test",
#     body: "text",
#     to: ["tim@example.com"]
#   )
module MicrosoftGraph
  class Client
    pattr_initialize [:tenant_id!, :client_id!, :client_secret!]

    class RequestFailed < StandardError; end

    def send_mail(from:, to:, subject:, body:, html: false)
      to = Array(to)
      access_token = fetch_access_token
      payload = build_email_payload(to: to, subject: subject, body: body, html: html)
      url = "https://graph.microsoft.com/v1.0/users/#{from}/sendMail"

      response = Faraday.post(
        url,
        payload,
        {
          "Authorization" => "Bearer #{access_token}",
          "Content-Type" => "application/json"
        }
      )
      raise(RequestFailed, error_description(response)) unless response.success?

      response
    end

    def fetch_access_token
      url = "https://login.microsoftonline.com/#{tenant_id}/oauth2/v2.0/token"

      response = Faraday.post(
        url,
        {
          "grant_type" => "client_credentials",
          "scope" => "https://graph.microsoft.com/.default",
          "client_id" => client_id,
          "client_secret" => client_secret
        }
      )
      raise(RequestFailed, error_description(response)) unless response.success?

      JSON.parse(response.body)["access_token"]
    end

    private

    def build_email_payload(to:, subject:, body:, html: false)
      {
        message: {
          subject: subject,
          body: {
            contentType: html ? "HTML" : "Text",
            content: body
          },
          toRecipients: to.map do |recip|
            {
              emailAddress: {
                address: recip
              }
            }
          end
        }
      }.to_json
    end

    def error_description(response)
      return if response.success?

      json = JSON.parse(response.body)
      json_attributes = json.map { |key, val| "#{key}: #{val}" }.join(" ")
      "#{response.status} #{json_attributes} response: #{response.inspect}"
    end
  end
end
