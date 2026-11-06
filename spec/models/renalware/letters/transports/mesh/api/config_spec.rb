module Renalware::Letters::Transports::Mesh
  describe API::Config do
    describe ".from_renalware" do
      it "maps every MESH API setting from Renalware.config" do
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

        expect(described_class.from_renalware).to have_attributes(
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

      it "reads Renalware.config when called, not when the class loads" do
        allow(Renalware.config).to receive(:mesh_mailbox_id).and_return("FIRST")
        first = described_class.from_renalware
        allow(Renalware.config).to receive(:mesh_mailbox_id).and_return("SECOND")

        expect(first.mailbox_id).to eq("FIRST")
        expect(described_class.from_renalware.mailbox_id).to eq("SECOND")
      end
    end

    it "can be built from plain values, with no Renalware.config" do
      config = described_class.new(
        mailbox_id: "MB1", mailbox_password: "p", api_secret: "s", api_base_url: "https://x",
        workflow_id: "WF", client_cert_path: nil, client_cert: "c", client_key_path: nil,
        client_key: "k", ca_file_path: "ca.pem", ca_cert: "ca", base_dir: Pathname("/tmp")
      )

      expect(config.mailbox_id).to eq("MB1")
      expect(config).to be_frozen
    end
  end
end
