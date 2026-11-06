module Renalware::Letters::Transports::Mesh
  # The MESH client itself lives in the relay-gp_connect gem and is specified there. This covers
  # what is Renalware's: it uses Renalware.config by default, with class-level shortcuts.
  describe API::Client do
    let(:mesh_mailbox_id) { "RAJ01OT001" }
    let(:base_url) { "http://localhost:8700/messageexchange" } # the MESH sandbox running in docker

    def cassette(path) = File.join("letters/transports/mesh/api", path)

    before do
      allow(Renalware.config).to receive_messages(
        mesh_mailbox_id:,
        mesh_api_base_url: base_url,
        mesh_path_to_client_cert: Rails.root.join("spec/support/dummy_mesh_cert.txt"),
        mesh_path_to_client_key: Rails.root.join("spec/support/dummy_mesh_key.txt")
      )
    end

    it "is the gem's client" do
      expect(described_class.superclass).to eq(Relay::GPConnect::Mesh::Client)
    end

    it "uses the settings in Renalware.config by default" do
      response = VCR.use_cassette(cassette("handshake/success")) { described_class.new.handshake }

      expect(response.status).to eq(200)
      expect(response.body).to eq("mailboxId" => mesh_mailbox_id)
    end

    it "has class-level shortcuts, e.g. handshake and send_message" do
      handshake = VCR.use_cassette(cassette("handshake/success")) { described_class.handshake }
      sent = VCR.use_cassette(cassette("send_message/naive")) do
        described_class.send_message(
          '<Bundle xmlns="http://hl7.org/fhir"></Bundle>',
          operation_uuid: "localID",
          to: "abc",
          subject: "xyz"
        )
      end

      expect(handshake.status).to eq(200)
      expect(sent.status).to eq(202)
    end

    it "responds to a shortcut for every client call" do
      %i(endpointlookup handshake check_inbox download_message acknowledge_message send_message)
        .each { |call| expect(described_class).to respond_to(call) }
    end

    # The gem's default clock is UTC; Renalware has always timestamped the auth header in London
    # time, so make sure the request that actually goes out still does.
    it "timestamps the authorization header in London time" do
      travel_to(Time.utc(2023, 7, 1, 12, 0)) do # BST: London is an hour ahead of UTC
        VCR.use_cassette(cassette("handshake/success")) { described_class.handshake }
      end

      expect(WebMock).to have_requested(:get, %r{/RAJ01OT001}).with { |request|
        request.headers["Authorization"].split(":")[3] == "202307011300"
      }
    end

    it "uses a config it is given, and never reads Renalware.config" do
      config = Relay::GPConnect::Mesh::Config.new(
        mailbox_id: mesh_mailbox_id, mailbox_password: "pass", api_secret: "secret",
        api_base_url: base_url, workflow_id: "WF",
        client_cert_path: Rails.root.join("spec/support/dummy_mesh_cert.txt"), client_cert: nil,
        client_key_path: Rails.root.join("spec/support/dummy_mesh_key.txt"), client_key: nil,
        ca_file_path: File.join(Dir.mktmpdir, "ca.pem"),
        ca_cert: Rails.root.join("spec/support/dummy_mesh_cert.txt").read,
        base_dir: Rails.root
      )
      allow(Renalware.config).to receive(:mesh_mailbox_id).and_raise("Renalware.config was read")
      allow(API::Config).to receive(:from_renalware).and_raise("Renalware.config was read")

      response = VCR.use_cassette(cassette("handshake/success")) do
        described_class.new(config:).handshake
      end

      expect(response.status).to eq(200)
    end
  end
end
