module Renalware::Letters::Transports::Mesh
  describe API::UrlHelpers do
    subject(:testobj) { Class.new { include API::UrlHelpers }.new }

    before do
      allow(Renalware.config).to receive_messages(
        mesh_api_base_url: "example.com",
        mesh_mailbox_id: "xyz"
      )
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

    it "msg_acknowledged" do
      expect(testobj.msg_acknowledged_path("msg1")).to eq("inbox/msg1/status/acknowledged")
    end
  end
end
