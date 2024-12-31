module Renalware
  describe NHSClient do
    let(:nhs_client) { described_class.new }
    let(:auth_uri) { "#{described_class::NHS_BASE_URL}/#{described_class::TOKEN_REQUEST_PATH}" }
    let(:query_uri) { "#{described_class::NHS_BASE_URL}/#{described_class::QUERY_PATH}" }

    describe "#api_enabled?" do
      context "when API credentials present" do
        before do
          stub_const("NHSClient::CLIENT_ID", 1)
          stub_const("NHSClient::CLIENT_SECRET", 1)
        end

        it "returns true" do
          expect(nhs_client.api_enabled?).to be true
        end
      end

      context "when API credentials absent" do
        before do
          stub_const("NHSClient::CLIENT_ID", nil)
          stub_const("NHSClient::CLIENT_SECRET", nil)
        end

        it "returns false" do
          expect(nhs_client.api_enabled?).to be false
        end
      end
    end

    describe "#problems" do
      before do
        stub_const("NHSClient::CLIENT_ID", "client_id")
        stub_const("NHSClient::CLIENT_SECRET", "client_secret")
        stub_request(:post, auth_uri).with(
          body: {
            "client_id" => "client_id",
            "client_secret" => "client_secret",
            "grant_type" => "client_credentials"
          }
        ).to_return(
          status: 200,
          body: File.read("spec/fixtures/files/nhs_client/token_response.json")
        )
      end

      context "with successfull query" do
        it "returns array with problems" do
          stub_request(
            :get,
            "#{query_uri}?count=10&filter=dis&includeDesignations=false&offset=0&url=http://snomed.info/sct?fhir_vs=ecl/%3C404684003%20OR%20%3C71388002"
          ).to_return(
            status: 200,
            body: File.read("spec/fixtures/files/nhs_client/query_response.json")
          )

          nhs_client.query("dis", count: 10)

          expected_first_problem = {
            "code" => "202233007",
            "display" => "Carpal instability with dorsal intercalated segment instability"
          }
          expect(nhs_client.problems.first).to eq(expected_first_problem)
          expect(nhs_client.problems.size).to eq(10)
        end
      end

      context "with failed authorisation" do
        it "returns an empty array" do
          stub_request(:post, auth_uri).with(
            body: {
              "client_id" => "client_id",
              "client_secret" => "client_secret",
              "grant_type" => "client_credentials"
            }
          ).to_return(status: 401, body: "")

          nhs_client.query("dis")
          expect(nhs_client.problems).to eq([])
        end
      end

      context "with failed query" do
        it "returns an empty array" do
          stub_request(
            :get,
            "#{query_uri}?count=20&filter=dis&includeDesignations=false&offset=0&url=http://snomed.info/sct?fhir_vs=ecl/%3C404684003%20OR%20%3C71388002"
          ).to_return(status: 500, body: "")

          nhs_client.query("dis")
          expect(nhs_client.problems).to eq([])
        end
      end
    end
  end
end
