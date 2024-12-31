# rubocop:disable Layout/LineLength
module Renalware::Letters::Transports::Mesh
  describe API::AuthHeader do
    it "generates a valid auth header string" do
      # AuthHeader uses Time.zone.now so make sure this will always return the same value
      travel_to(Time.zone.parse("2023-01-31 09:01")) do
        header = described_class.call(
          mailbox_id: "ID",
          mailbox_password: "PASS",
          mesh_api_secret: "SEC",
          nonce: "NONCE" # passed only in tests to prevent randomisation
        )

        expect(header).to eq(
          "NHSMESH ID:NONCE:0:202301310901:7e13e62fb49c606806b1566130d57302be04fa7d42215865b39b3fee7f6fa48a"
        )
      end
    end
  end
end
# rubocop:enable Layout/LineLength
