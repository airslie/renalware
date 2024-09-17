# frozen_string_literal: true

module Renalware::Letters::Transports::Mesh
  describe HandshakeJob do
    it "calls a handshake method on the API client" do
      allow(API::Client).to receive(:handshake)

      described_class.new.perform

      expect(API::Client).to have_received(:handshake)
    end
  end
end
