module Renalware
  module Letters::Formats::FHIR
    # Building the GP Connect Send Document message (FHIR STU3 XML) lives in the relay-gp_connect
    # gem (gems/relay-gp_connect), which Relay shares. These are its pieces, under their familiar
    # names. Renalware's part is Arguments (below), which builds the gem's input from a
    # Transmission, and BuildDeliveryRequest, which maps a letter to that input.
    BuildPayload = Relay::GPConnect::FHIR::BuildPayload
    Resources = Relay::GPConnect::FHIR::Resources
    Support = Relay::GPConnect::FHIR::Support
  end
end
