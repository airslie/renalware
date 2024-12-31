require "httparty"

# Usage:
#
#   client = NHSClient.new
#   client.query('test')
#   client.problems
#
class NHSClient
  NHS_BASE_URL = ENV.fetch(
    "NHS_TERMINOLOGY_SERVER_BASE_URL",
    "https://ontology.nhs.uk"
  )
  TOKEN_REQUEST_PATH = ENV.fetch(
    "NHS_TERMINOLOGY_SERVER_TOKEN_REQUEST_PATH",
    "authorisation/auth/realms/nhs-digital-terminology/protocol/openid-connect/token"
  )
  QUERY_PATH = ENV.fetch(
    "NHS_TERMINOLOGY_SERVER_QUERY_PATH",
    "production1/fhir/ValueSet/$expand"
  )

  # Expression Constraint Language (ECL) to scope the $expand call.
  # This quetry (see https://ontoserver.csiro.au/shrimp/ecl_help.html) will search descendants of
  # the prodecure concept (71388002) and descendants of the clinical findings concept (404684003)
  ECL = ENV.fetch("NHS_TERMINOLOGY_SERVER_ECL", "<404684003 OR <71388002")

  CLIENT_ID = Renalware.config.nhs_client_id
  CLIENT_SECRET = Renalware.config.nhs_client_secret

  attr_reader :problems, :problems_total

  def initialize
    @problems = []
    @problems_total = 0
  end

  def api_enabled?
    (CLIENT_ID && CLIENT_SECRET).present?
  end

  def query(filter, count: 20, offset: 0, include_designations: false)
    return false unless (token = bearer_token)

    response = HTTParty.get(
      "#{NHS_BASE_URL}/#{QUERY_PATH}",
      headers: {
        "Authorization" => "Bearer #{token}"
      },
      query: {
        url: "http://snomed.info/sct?fhir_vs=ecl/#{ECL}",
        filter: filter,
        count: count,
        offset: offset,
        includeDesignations: include_designations
      },
      timeout: 10
    )
    return false unless response.code == 200

    response_body = JSON.parse(response.body)
    @problems = response_body["expansion"]["contains"]&.map { |h| h.slice("code", "display") } || []
    @problems_total = response_body["expansion"]["total"]

    response_body
  rescue JSON::ParserError, SocketError
    false
  end

  private

  def bearer_token
    response = HTTParty.post(
      "#{NHS_BASE_URL}/#{TOKEN_REQUEST_PATH}",
      headers: {
        "Content-Type" => "application/x-www-form-urlencoded"
      },
      body: {
        client_id: CLIENT_ID,
        client_secret: CLIENT_SECRET,
        grant_type: "client_credentials"
      },
      timeout: 20
    )

    return false unless response.code == 200

    JSON.parse(response.body)["access_token"]
  rescue JSON::ParserError, SocketError
    false
  end
end
