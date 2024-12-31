require "faraday"

module Renalware
  module Drugs::DMD
    class OntologyClient
      include Callable

      ENDPOINT = "https://ontology.nhs.uk".freeze
      CLIENT_ID = Renalware.config.nhs_client_id
      CLIENT_SECRET = Renalware.config.nhs_client_secret
      ACCESS_TOKEN_URL = "https://ontology.nhs.uk/authorisation/auth/realms/nhs-digital-terminology/protocol/openid-connect/token".freeze

      class Unauthenticated < StandardError; end

      class RequestFailed < StandardError
        def initialize(message = nil, response: nil)
          status = response.status if response.respond_to?(:status)
          hash = response.to_hash if response.respond_to?(:to_hash)
          super("#{message} status: #{status} response: #{hash}")
        end
      end

      class NoData < StandardError; end

      # Note due to the Callable concern you execute #call on the class
      #   OntologyClient.call => OntologyClient.new.call
      # or OntologyClient.new.call directly
      def call
        Faraday.new(
          url: ENDPOINT,
          request: { params_encoder: Faraday::FlatParamsEncoder },
          headers: {
            "Content-Type" => "application/json",
            "Authorization" => "Bearer #{access_token}"
          }
        ) do |f|
          f.response :json
        end
      end

      def access_token
        response = Faraday.post(
          ACCESS_TOKEN_URL,
          {
            client_id: CLIENT_ID,
            client_secret: CLIENT_SECRET,
            grant_type: "client_credentials"
          }
        )

        return Unauthenticated unless response.success?

        JSON.parse(response.body)["access_token"]
      rescue JSON::ParserError, SocketError
        raise Unauthenticated
      end
    end
  end
end
