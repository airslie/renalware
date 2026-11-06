module Renalware::Letters::Transports::Mesh
  describe API::Config do
    it "from_renalware maps every MESH API setting from Renalware.config" do
      allow(Renalware.config).to receive_messages(
        mesh_mailbox_id: "MB1",
        mesh_mailbox_password: "pass",
        mesh_api_secret: "secret",
        mesh_api_base_url: "https://mesh.example/messageexchange",
        mesh_workflow_id: "WF1",
        mesh_path_to_client_cert: "certs/client.cer",
        mesh_client_cert: "CERT CONTENTS",
        mesh_path_to_client_key: "certs/client.key",
        mesh_client_key: "KEY CONTENTS",
        mesh_path_to_nhs_ca_file: "certs/ca.pem",
        mesh_nhs_ca_cert: "CA CONTENTS"
      )

      config = described_class.from_renalware

      expect(config).to be_a(Relay::GPConnect::Mesh::Config)
      expect(config).to have_attributes(
        mailbox_id: "MB1",
        mailbox_password: "pass",
        api_secret: "secret",
        api_base_url: "https://mesh.example/messageexchange",
        workflow_id: "WF1",
        client_cert_path: "certs/client.cer",
        client_cert: "CERT CONTENTS",
        client_key_path: "certs/client.key",
        client_key: "KEY CONTENTS",
        ca_file_path: "certs/ca.pem",
        ca_cert: "CA CONTENTS",
        base_dir: Rails.root
      )
    end

    it "from_renalware reads Renalware.config when called, not when the class loads" do
      allow(Renalware.config).to receive(:mesh_mailbox_id).and_return("FIRST")
      first = described_class.from_renalware
      allow(Renalware.config).to receive(:mesh_mailbox_id).and_return("SECOND")

      expect(first.mailbox_id).to eq("FIRST")
      expect(described_class.from_renalware.mailbox_id).to eq("SECOND")
    end

    # The MESH auth header has always been timestamped in the application's time zone (London),
    # not UTC. The gem defaults to UTC, so Renalware must pass its own clock.
    it "from_renalware timestamps using the application's time zone (London), not UTC" do
      travel_to(Time.utc(2023, 7, 1, 12, 0)) do # BST: London is an hour ahead of UTC
        expect(described_class.from_renalware.clock.call.strftime("%H:%M")).to eq("13:00")
      end
    end
  end
end
