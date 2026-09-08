module Renalware
  module Heidi
    class SessionsClient < BaseClient
      def initialize(client: Client.new, connection: nil, api_key: Renalware.config.heidi_api_key)
        super(connection:, api_key:)
        @client = client
      end

      def create(user)
        with_jwt(user) do |token|
          response = connection.post("sessions") do |request|
            request.headers["Authorization"] = "Bearer #{token}"
            request.headers["Heidi-Api-Key"] = api_key
            request.headers["Content-Type"] = "application/json"
            request.body = {}.to_json
          end

          result_from(response)
        end
      end

      def update(user, session_id, payload)
        with_jwt(user) do |token|
          response = connection.patch("sessions/#{session_id}") do |request|
            request.headers["Authorization"] = "Bearer #{token}"
            request.headers["Heidi-Api-Key"] = api_key
            request.headers["Content-Type"] = "application/json"
            request.body = payload.to_json
          end

          result_from(response)
        end
      end

      def get(user, session_id)
        with_jwt(user) do |token|
          response = connection.get("sessions/#{session_id}") do |request|
            request.headers["Authorization"] = "Bearer #{token}"
            request.headers["Heidi-Api-Key"] = api_key
          end

          result_from(response)
        end
      end

      def documents(user, session_id)
        with_jwt(user) do |token|
          response = connection.get("sessions/#{session_id}/documents") do |request|
            request.headers["Authorization"] = "Bearer #{token}"
            request.headers["Heidi-Api-Key"] = api_key
          end

          result_from(response)
        end
      end

      private

      attr_reader :client

      def jwt_source
        client
      end
    end
  end
end
