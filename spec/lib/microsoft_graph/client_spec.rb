describe MicrosoftGraph::Client do
  subject(:client) do
    described_class.new(
      tenant_id: tenant_id,
      client_id: client_id,
      client_secret: client_secret
    )
  end

  let(:tenant_id) { "123" }
  let(:client_id) { "456" }
  let(:client_secret) { "789" }
  let(:sending_email_address) { "a@b.com" }

  def stub_fetch_token(token = "thetoken")
    stub_request(:post, "https://login.microsoftonline.com/123/oauth2/v2.0/token")
      .with(
        body: {
          client_id: 456,
          client_secret: 789,
          grant_type: "client_credentials",
          scope: "https://graph.microsoft.com/.default"
        }
      ).to_return(status: 200, body: { access_token: token }.to_json, headers: {})
  end

  describe "#fetch_access_token" do
    it "uses client credentials OAuth flow to get an access token" do
      stub_fetch_token("thetoken")

      expect(client.fetch_access_token).to eq("thetoken")
    end
  end

  describe "#send_mail" do
    it "sends an email via the MS graph API" do
      stub_fetch_token("thetoken")

      expected_body = {
        message: {
          subject: "The subject",
          body: {
            contentType: "Text",
            content: "The body"
          },
          toRecipients: [
            {
              emailAddress: {
                address: "test@example.com"
              }
            }
          ]
        }
      }.to_json

      stub_request(:post, "https://graph.microsoft.com/v1.0/users/a@b.com/sendMail")
        .with(
          body: expected_body,
          headers: { "Authorization" => "Bearer thetoken" }
        ).to_return(status: 202, body: "", headers: {})

      client.send_mail(
        from: sending_email_address,
        to: "test@example.com",
        subject: "The subject",
        body: "The body"
      )
    end

    pending "send_mail when error - check error is raised"
  end
end
