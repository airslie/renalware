RSpec.describe Relay::GPConnect::Mesh::Config do
  it "is built from plain values, with no global configuration" do
    config = build_mesh_config(mailbox_id: "MB1")

    expect(config.mailbox_id).to eq("MB1")
    expect(config).to be_frozen
  end

  it "defaults the clock to UTC now" do
    now = Time.utc(2023, 1, 31, 9, 1)

    travel_to(now) do
      expect(build_mesh_config.clock.call).to eq(now)
      expect(build_mesh_config.clock.call.utc_offset).to eq(0)
    end
  end

  it "uses the clock it is given" do
    config = build_mesh_config(clock: -> { Time.utc(2000, 1, 1) })

    expect(config.clock.call).to eq(Time.utc(2000, 1, 1))
  end
end
