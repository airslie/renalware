# The UrlHelpers module needs its includer to provide a config
class UrlHelpersHarness
  include Relay::GPConnect::Mesh::UrlHelpers

  attr_reader :config

  def initialize(config)
    @config = config
  end
end

RSpec.describe Relay::GPConnect::Mesh::UrlHelpers do
  subject(:testobj) { UrlHelpersHarness.new(config) }

  let(:config) do
    build_mesh_config(api_base_url: "example.com", mailbox_id: "xyz", workflow_id: "MY_WORKFLOW")
  end

  it "base" do
    expect(testobj.base_url).to eq("example.com/xyz")
  end

  it "handshake" do
    expect(testobj.handshake_path).to eq("")
  end

  it "inbox" do
    expect(testobj.inbox_path).to eq("inbox")
  end

  it "outbox" do
    expect(testobj.outbox_path).to eq("outbox")
  end

  it "download_message" do
    expect(testobj.download_message_path("msg1")).to eq("inbox/msg1")
  end

  it "endpointlookup uses the base url (not the mailbox), the practice ods code and workflow" do
    expect(testobj.endpointlookup_path("A81013"))
      .to eq("example.com/endpointlookup/A81013/MY_WORKFLOW")
  end

  it "msg_acknowledged" do
    expect(testobj.msg_acknowledged_path("msg1")).to eq("inbox/msg1/status/acknowledged")
  end
end
