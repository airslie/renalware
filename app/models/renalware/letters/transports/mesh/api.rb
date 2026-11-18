module Renalware
  module Letters::Transports::Mesh
    # The MESH API client, request/response handling and the parsing of what comes back live in the
    # relay-gp_connect gem (gems/relay-gp_connect), which Relay shares. These are the parts
    # Renalware uses, under their familiar names. What stays here is what is Renalware's:
    # Config.from_renalware, a Client that uses it by default, and LogOperation, which stores
    # each call as an Operation.
    module API
      ITK3Response = Relay::GPConnect::Mesh::ITK3Response
      ResponseHeaders = Relay::GPConnect::Mesh::ResponseHeaders
      OperationAttributes = Relay::GPConnect::Mesh::OperationAttributes
      Errors = Relay::GPConnect::Mesh::Errors
    end
  end
end
