RSpec.describe Relay::GPConnect::Mesh::AuthHeader do
  # rubocop:disable-next Layout/LineLength
  let(:expected) { "NHSMESH ID:NONCE:0:202301310901:7e13e62fb49c606806b1566130d57302be04fa7d42215865b39b3fee7f6fa48a" }

  it "generates a valid auth header string" do
    config = build_mesh_config(mailbox_id: "ID", mailbox_password: "PASS", api_secret: "SEC")

    # The timestamp comes from the config's clock (UTC now by default): freeze it
    travel_to(Time.utc(2023, 1, 31, 9, 1)) do
      header = described_class.call(
        config:,
        nonce: "NONCE" # passed only in tests to prevent randomisation
      )

      expect(header).to eq(expected)
    end
  end

  it "timestamps using the clock in the config, so the host decides the time zone" do
    config = build_mesh_config(
      mailbox_id: "ID", mailbox_password: "PASS", api_secret: "SEC",
      clock: -> { Time.utc(2023, 1, 31, 9, 1) }
    )

    expect(described_class.call(config:, nonce: "NONCE")).to eq(expected)
  end

  it "defaults to UTC now, with a nonce of a fresh uuid each time" do
    config = build_mesh_config

    first = described_class.call(config:)
    second = described_class.call(config:)

    expect(first).to match(/\ANHSMESH RAJ01OT001:[0-9a-f-]{36}:0:\d{12}:[0-9a-f]{64}\z/)
    expect(first).not_to eq(second)
  end
end
