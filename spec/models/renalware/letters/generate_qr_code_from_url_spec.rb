# frozen_string_literal: true

module Renalware
  module Letters
    describe GenerateQRCodeFromUrl do
      it "returns an svg representation of a QR code" do
        svg = described_class.new("http://example.com").call
        expect(svg).to match("<svg")
      end
    end
  end
end
