require "httparty"

module Renalware
  module Letters::Transports::Mesh
    # Generate an auth heaer to send with each api request.
    # See https://digital.nhs.uk/developer/api-catalogue/message-exchange-for-social-care-
    #   and-health-api#api-description__mesh-authorization-header for details
    class API::AuthHeader
      include Callable

      # Nonce can be passed but it is only used for testing so we can get back a consistent
      # header result. Otherwise we create a unique nonce on each request.
      def initialize(mailbox_id: nil, mailbox_password: nil, mesh_api_secret: nil, nonce: nil)
        @mailbox_id = mailbox_id || Renalware.config.mesh_mailbox_id
        @mailbox_password = mailbox_password || Renalware.config.mesh_mailbox_password
        @api_secret = mesh_api_secret || Renalware.config.mesh_api_secret
        @nonce = nonce || SecureRandom.uuid
        @nonce_count = 0
      end

      # Our simplistic implementation does not increment nonce_count but instead generates a new
      # nonce on each request so nonce_count can always be 0.
      # I can't see any advantage to reusing a nonce and incrementing nonce_count.
      def call
        parts = [
          mailbox_id,
          nonce,
          nonce_count.to_s,
          timestamp,
          auth_hash
        ]
        "NHSMESH #{parts.join(':')}"
      end

      private

      attr_reader :mailbox_id, :mailbox_password, :api_secret, :nonce, :nonce_count

      # HMAC-SHA256 hash
      def hash(data)
        digest = OpenSSL::Digest.new("sha256")
        OpenSSL::HMAC.hexdigest(digest, api_secret, data)
      end

      def auth_hash
        parts = [
          mailbox_id,
          nonce,
          nonce_count,
          mailbox_password,
          timestamp
        ]
        hash(parts.join(":"))
      end

      # Returns e.g. "202302231230"
      def timestamp
        @timestamp ||= Time.zone.now.strftime("%Y%m%d%H%M")
      end
    end
  end
end
