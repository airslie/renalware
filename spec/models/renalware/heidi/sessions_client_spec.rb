describe Renalware::Heidi::SessionsClient do
  subject(:sessions_client) do
    described_class.new(client:, connection:, api_key: "test-api-key")
  end

  let(:client) { instance_double(Renalware::Heidi::Client) }
  let(:connection) do
    Faraday.new do |faraday|
      faraday.request :json
      faraday.response :json
      faraday.adapter(:test, stubs)
    end
  end
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:user) { build_stubbed(:user) }

  before do
    allow(client).to receive(:jwt_for).with(user).and_return(
      Renalware::Heidi::Client::Result.new(
        success: true,
        status: 200,
        body: { "token" => "jwt-token" }
      )
    )
  end

  describe "#create" do
    it "creates a session using the generated JWT" do
      stub_create_session

      result = sessions_client.create(user)

      expect(result).to be_success
      expect(result.body).to eq("session_id" => "1234567890")
      stubs.verify_stubbed_calls
    end
  end

  describe "#update" do
    it "patches Heidi session context" do
      stub_update_session

      result = sessions_client.update(
        user,
        "1234567890",
        clinician_notes: ["Renalware patient problems:", "- Diabetes mellitus"]
      )

      expect(result).to be_success
      stubs.verify_stubbed_calls
    end
  end

  describe "#get" do
    it "fetches Heidi session details" do
      stub_session_details

      result = sessions_client.get(user, "session-1")

      expect(result).to be_success
      expect(result.body).to eq("session" => { "session_id" => "session-1" })
      stubs.verify_stubbed_calls
    end
  end

  describe "#documents" do
    it "fetches all documents using the session owner's JWT" do
      stub_documents

      result = sessions_client.documents(user, "session-1")

      expect(result).to be_success
      expect(result.body).to eq("documents" => [])
      stubs.verify_stubbed_calls
    end
  end

  def stub_documents
    stubs.get("sessions/session-1/documents") do |env|
      expect(env.request_headers["Authorization"]).to eq("Bearer jwt-token")
      expect(env.request_headers["Heidi-Api-Key"]).to eq("test-api-key")
      [200, { "Content-Type" => "application/json" }, { documents: [] }.to_json]
    end
  end

  def stub_create_session
    stubs.post("sessions") do |env|
      expect(env.request_headers["Authorization"]).to eq("Bearer jwt-token")
      expect(env.request_headers["Heidi-Api-Key"]).to eq("test-api-key")
      expect(JSON.parse(env.body)).to eq({})

      [200, { "Content-Type" => "application/json" }, { session_id: "1234567890" }.to_json]
    end
  end

  def stub_update_session
    stubs.patch("sessions/1234567890") do |env|
      expect(env.request_headers["Authorization"]).to eq("Bearer jwt-token")
      expect(env.request_headers["Heidi-Api-Key"]).to eq("test-api-key")
      expect(JSON.parse(env.body)).to eq(
        "clinician_notes" => [
          "Renalware patient problems:",
          "- Diabetes mellitus"
        ]
      )

      [200, { "Content-Type" => "application/json" }, { session_id: "1234567890" }.to_json]
    end
  end

  def stub_session_details
    stubs.get("sessions/session-1") do |env|
      expect(env.request_headers["Authorization"]).to eq("Bearer jwt-token")
      expect(env.request_headers["Heidi-Api-Key"]).to eq("test-api-key")

      [
        200,
        { "Content-Type" => "application/json" },
        { session: { session_id: "session-1" } }.to_json
      ]
    end
  end
end
