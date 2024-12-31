Before do
  Renalware.config.nhs_client_id = "client_id"
  Renalware.config.nhs_client_secret = "client_secret"

  auth_uri = "#{NHSClient::NHS_BASE_URL}/#{NHSClient::TOKEN_REQUEST_PATH}"
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

  query_uri = "#{NHSClient::NHS_BASE_URL}/#{NHSClient::QUERY_PATH}"

  %w(major%20problem something%20else).each do |filter|
    stub_request(
      :get,
      "#{query_uri}?count=10&filter=#{filter}&includeDesignations=false&offset=0&url=http://snomed.info/sct?fhir_vs=ecl/%3C404684003%20OR%20%3C71388002"
    ).to_return(
      status: 200,
      body: File.read("spec/fixtures/files/nhs_client/query_response.json")
    )
    stub_request(
      :get,
      "#{query_uri}?count=10&filter=#{filter}&includeDesignations=false&offset=20&url=http://snomed.info/sct?fhir_vs=ecl/%3C404684003%20OR%20%3C71388002"
    ).to_return(
      status: 200,
      body: File.read("spec/fixtures/files/nhs_client/query_response.json")
    )
  end
end

After do
  Renalware.config.nhs_client_id = nil
  Renalware.config.nhs_client_secret = nil
end
