module Renalware::Letters::Transports::Mesh
  # Not too sure what we are testing here as we could end up testing the NHS MESH docker sandbox
  # rather than our app! Validating various VCR cassettes is useful however
  describe API::Client do
    let(:mesh_mailbox_id) { "RAJ01OT001" }
    let(:base_url) { "http://localhost:8700/messageexchange" } # the MESH sandbox running in docker

    def cassette(path)
      File.join("letters/transports/mesh/api", path)
    end

    before do
      # Note you can run a meshapi sandbox on localhost:8700 using docker
      # https://github.com/NHSDigital/mesh-sandbox
      allow(Renalware.config).to receive_messages(
        mesh_mailbox_id: mesh_mailbox_id,
        mesh_api_base_url: base_url,
        mesh_path_to_client_cert: Renalware::Engine.root.join("spec/support/dummy_mesh_cert.txt"),
        mesh_path_to_client_key: Renalware::Engine.root.join("spec/support/dummy_mesh_key.txt")
      )
    end

    describe "#handshake" do
      context "when the mailbox does not exist" do
        it "returns 403 and a json response with an EPL error" do
          allow(Renalware.config).to receive(:mesh_mailbox_id).and_return("BADMAILBOX")
          response = VCR.use_cassette(cassette("handshake/mailbox_not_found")) do
            described_class.handshake
          end

          expect(response.status).to eq(403)
          expect(response.body).to include("errorCode" => "EPL-151")
        end
      end

      context "when the mailbox exists" do
        it "returns true" do
          response = VCR.use_cassette(cassette("handshake/success")) do
            described_class.new.handshake
          end

          expect(response.status).to eq(200)
          expect(response.body).to eq("mailboxId" => mesh_mailbox_id)
        end
      end
    end

    describe "#check_inbox" do
      it do
        response = VCR.use_cassette(cassette("check_inbox/no_messages")) do
          described_class.new.check_inbox
        end

        expect(response.status).to eq(200)
        expect(response.body).to eq("messages" => [])
      end
    end

    describe "#download_message" do
      context "when the message does not exist" do
        it do
          response = VCR.use_cassette(cassette("download_message/not_found")) do
            described_class.new.download_message("123")
          end

          expect(response.status).to eq(404)
          expect(response.body).to include("errorDescription" => "Message does not exist")
        end
      end

      it "downloading a simple message created with curl!" do
        response = VCR.use_cassette(
          cassette("download_message/60A7BB96B4974B5D8CD50E28CB782795")
        ) do
          described_class.new.download_message("60A7BB96B4974B5D8CD50E28CB782795")
        end

        expect(response.status).to eq(200)
        expect(response.body).to eq("This is a message")
      end
    end

    describe "#send_message" do
      it "send simple empty Bundle XML message" do
        response = VCR.use_cassette(cassette("send_message/naive")) do
          described_class.send_message(
            '<Bundle xmlns="http://hl7.org/fhir"></Bundle>',
            operation_uuid: "localID",
            to: "abc",
            subject: "xyz"
          )
        end

        expect(response.status).to eq(202)
        expect(response.body).to eq("messageID" => "DC15F15F29D5487EA444310EE5222322")
      end
    end
  end
end
