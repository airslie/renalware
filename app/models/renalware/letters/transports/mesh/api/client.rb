module Renalware
  module Letters::Transports::Mesh
    module API
      # The MESH API client from the relay-gp_connect gem, using Renalware's settings by default,
      # plus class-level shortcuts so callers can write API::Client.send_message(...).
      # See Relay::GPConnect::Mesh::Client for what each call does.
      class Client < Relay::GPConnect::Mesh::Client
        def self.endpointlookup(...)      = new.endpointlookup(...)
        def self.handshake(...)           = new.handshake(...)
        def self.check_inbox(...)         = new.check_inbox(...)
        def self.download_message(...)    = new.download_message(...)
        def self.acknowledge_message(...) = new.acknowledge_message(...)
        def self.send_message(...)        = new.send_message(...)

        def initialize(config: Config.from_renalware)
          super
        end
      end
    end
  end
end
