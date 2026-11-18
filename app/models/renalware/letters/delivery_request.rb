module Renalware
  module Letters
    # Everything needed to deliver one letter electronically to a patient's GP, as plain values.
    # The class lives in the relay-gp_connect gem (gems/relay-gp_connect), which Relay shares;
    # Renalware builds one with BuildDeliveryRequest.
    DeliveryRequest = Relay::GPConnect::DeliveryRequest
  end
end
