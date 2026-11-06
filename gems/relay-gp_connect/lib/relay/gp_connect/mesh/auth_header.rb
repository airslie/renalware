require "openssl"
require "securerandom"

module Relay
  module GPConnect
    module Mesh
      # Generate an auth header to send with each api request.
      # See https://digital.nhs.uk/developer/api-catalogue/message-exchange-for-social-care-
      #   and-health-api#api-description__mesh-authorization-header for details
      class AuthHeader
        def self.call(...) = new(...).call

        # Nonce can be passed but it is only used for testing so we can get back a consistent
        # header result. Otherwise we create a unique nonce on each request.
        def initialize(config:, nonce: nil)
          @config = config
          @nonce = nonce || SecureRandom.uuid
          @nonce_count = 0
        end

        # Our simplistic implementation does not increment nonce_count but instead generates a new
        # nonce on each request so nonce_count can always be 0.
        # I can't see any advantage to reusing a nonce and incrementing nonce_count.
        def call
          parts = [
            config.mailbox_id,
            nonce,
            nonce_count.to_s,
            timestamp,
            auth_hash
          ]
          "NHSMESH #{parts.join(':')}"
        end

        private

        attr_reader :config, :nonce, :nonce_count

        # HMAC-SHA256 hash
        def hash(data)
          digest = OpenSSL::Digest.new("sha256")
          OpenSSL::HMAC.hexdigest(digest, config.api_secret, data)
        end

        def auth_hash
          parts = [
            config.mailbox_id,
            nonce,
            nonce_count,
            config.mailbox_password,
            timestamp
          ]
          hash(parts.join(":"))
        end

        # Returns e.g. "202302231230"
        def timestamp
          @timestamp ||= config.clock.call.strftime("%Y%m%d%H%M")
        end
      end
    end
  end
end
