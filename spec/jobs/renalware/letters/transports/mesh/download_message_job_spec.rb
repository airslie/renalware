module Renalware::Letters::Transports
  module Mesh
    describe DownloadMessageJob do
      include FaradayHelper
      include LettersSpecHelper
      include MeshSpecHelper

      let(:dummy_cert) {
        <<~CERT.squish
          -----BEGIN CERTIFICATE-----
          MIIB4TCCAYugAwIBAgIUKgirkph4+M8xyXY09xldX8ZHWdUwDQYJKoZIhvcNAQEL
          BQAwRTELMAkGA1UEBhMCQVUxEzARBgNVBAgMClNvbWUtU3RhdGUxITAfBgNVBAoM
          GEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZDAeFw0yNTA3MDQwOTIyMzlaFw0yODAz
          MzAwOTIyMzlaMEUxCzAJBgNVBAYTAkFVMRMwEQYDVQQIDApTb21lLVN0YXRlMSEw
          HwYDVQQKDBhJbnRlcm5ldCBXaWRnaXRzIFB0eSBMdGQwXDANBgkqhkiG9w0BAQEF
          AANLADBIAkEAuNWTxVofoMlbQuE0pcvP6eVhsMmw5SlRbinlfKEPSbLQKf5Vq/Kv
          sBCsiBXAQPFOYMIv4gZIOCiX/7roMo8cqQIDAQABo1MwUTAdBgNVHQ4EFgQUCZir
          d0bX+R1ugb00K9yaE+uoCY0wHwYDVR0jBBgwFoAUCZird0bX+R1ugb00K9yaE+uo
          CY0wDwYDVR0TAQH/BAUwAwEB/zANBgkqhkiG9w0BAQsFAANBAAh4KLMgw/LRq7gp
          KMxdyy7DnXcPNYVJbVnaxPgL4jSsmS5hD3qejPggDW4qn3FcAER3M7c383N59osf
          061473M=
          -----END CERTIFICATE-----
        CERT
      }

      let(:dummy_key) {
        <<~KEY.squish
          -----BEGIN PRIVATE KEY-----
          MIIBVAIBADANBgkqhkiG9w0BAQEFAASCAT4wggE6AgEAAkEAuNWTxVofoMlbQuE0
          pcvP6eVhsMmw5SlRbinlfKEPSbLQKf5Vq/KvsBCsiBXAQPFOYMIv4gZIOCiX/7ro
          Mo8cqQIDAQABAkB3nhj09n9TghxiqvZ0efNDTqSrUcv+cn/1iH2w61bGfS1wZP47
          J7V1UfCKpsfyi4XNozK85ic2oOq2Rm12IOsBAiEA5zsd38Gbt+BK26wP+BAxWsgw
          idNe7Pa2VkEmXcVct8kCIQDMoih4kf4qFArOjmSjavgYYjvgYBi6UnkG6uUVzclt
          4QIgUiJWjzdnR549GOB6X6Po1BVN4HcbPdK4m9TSevZy47kCIQCHZNtmOyJx8OTd
          mjVYMtSIPabkZHC4Bw1w2EZO0OPvwQIgO2WNFCXcvgjnVZFSSeu28qYywwDSKwL5
          MJpJFFk2YmI=
          -----END PRIVATE KEY-----
        KEY
      }

      let(:transmission) { Mesh::Transmission.create!(letter: letter) }
      let(:user) { create(:user) }
      let(:send_operation_uuid) { "75155665-d300-4319-a7a4-3b6f3f38e739" }
      let(:letter) do
        create_mesh_letter(
          patient: create_mesh_patient(user: user),
          user: user
        )
      end
      let(:send_operation) {
        Mesh::Operation.create!(
          transmission: transmission,
          action: :send_message,
          uuid: send_operation_uuid
        )
      }

      def cassette(path) = File.join("letters/transports/mesh/api", path)

      it "downloads a FHIR XML document via the api" do
        message_id = "123"
        send_operation.reload
        xml = <<-XML
          <Bundle> <!-- Simplified! -->
            <entry>
              <resource>
                <MessageHeader>
                  <response>
                    <identifier value="#{send_operation.uuid}"/>
                  </response>
                </MessageHeader>
              </resource>
            </entry>
          </Bundle>
        XML

        response = mock_faraday_response(
          body: xml,
          headers: { "mex-localid" => send_operation_uuid }
        )

        allow(API::Client).to receive_messages(
          download_message: response,
          acknowledge_message: response
        )

        described_class.new.perform(message_id)

        expect(API::Client).to have_received(:download_message).with(message_id)
        expect(API::Client).to have_received(:acknowledge_message).with(message_id)
      end

      it "does not call acknowledge_message if an error is raised during download_message" do
        message_id = "123"
        response = mock_faraday_response(headers: { "mex-localid" => send_operation_uuid })
        allow(API::Client).to receive(:download_message).and_raise(ArgumentError)
        allow(API::Client).to receive(:acknowledge_message).and_return(response)

        expect {
          described_class.new.perform(message_id)
        }.to raise_error ArgumentError

        expect(API::Client).to have_received(:download_message).with(message_id)
        expect(API::Client).not_to have_received(:acknowledge_message).with(message_id)
      end

      context "when a REPORT message is downloaded (no body, only headers), indicating an " \
              "async error eg undeliverable after 5 days" do
        # rubocop:disable RSpec/ExampleLength
        it "identifies the corresponding parent send_message operation, and stores its id, " \
           "the id of the transmission, and the error info in the REPORT, in a new download " \
           "operation" do
          message_id = "123"
          send_operation

          # We are going to use a VCR cassette to return the REPORT message waiting in the inbox.
          # However, because we also need to mock the response to the acknowledge_message call,
          # and we can't use VCR for that (can you have two VCR cassettes in one test?),
          # we will mock the response to acknowledge_message here.
          allow(API::Client)
            .to receive(:acknowledge_message)
            .and_return(
              mock_faraday_response(
                body: "",
                headers: { "Content-Type" => "application/json" }
              )
            )

          # Make sure the MESH API base URL is set to the one we use in VCR.
          allow(Renalware.config).to receive_messages(
            mesh_api_base_url: "http://localhost:8700/messageexchange",
            mesh_client_cert: dummy_cert,
            mesh_client_key: dummy_key,
            mesh_mailbox_id: "RAJ01OT001"
          )

          VCR.use_cassette(
            cassette("download_message/report/undelivered"),
            erb: { local_id: send_operation_uuid }
          ) do
            # NB Can use a nested VCR block here for the PUT ACK but I could not get it to work
            # so using am stubbing acknowledge_message instead - see above
            # VCR.use_cassette(
            #   cassette("acknowledge/success"),
            #   erb: { mesh_message_id: message_id }
            # ) do
            expect {
              described_class.new.perform(message_id)
            }.to change(Operation, :count).by(2) # download_message, acknowledge_message
            # end
          end

          operations = Operation.order(created_at: :asc)

          expect(operations[0]).to have_attributes(
            transmission_id: transmission.id,
            action: "send_message"
          )
          expect(operations[1]).to have_attributes(
            transmission_id: transmission.id,
            parent_id: send_operation.id,
            action: "download_message",
            mesh_error: true,
            mesh_response_error_event: nil,
            mesh_response_error_code: "14",
            mesh_response_error_description: "Undelivered message"
          )
          expect(operations[2]).to have_attributes(
            transmission_id: transmission.id,
            parent_id: send_operation.id, # should be the download message operation?
            action: "acknowledge_message"
          )
        end

        it "removes the msg from the inbox even if there is no parent transmission " \
           "ie this message was perhaps sent to our mailbox accidentally" do
          message_id = "123"
          unrecognised_uuid = SecureRandom.uuid
          unrecognised_mesh_msg_id = "unrecognised-mesh-message-id"

          # Make sure the MESH API base URL is set to the one we use in VCR.
          allow(Renalware.config).to receive_messages(
            mesh_api_base_url: "http://localhost:8700/messageexchange",
            mesh_client_cert: dummy_cert,
            mesh_client_key: dummy_key,
            mesh_mailbox_id: "RAJ01OT001"
          )

          response = mock_faraday_response(
            headers: {
              "Content-Type" => "application/json"
            }
          )

          allow(API::Client).to receive_messages(acknowledge_message: response)

          VCR.use_cassette(
            cassette("download_message/report/undelivered"),
            erb: { local_id: unrecognised_uuid, linked_msg_id: unrecognised_mesh_msg_id }
          ) do
            expect {
              described_class.new.perform(message_id)
            }.to change(Operation, :count).by(2) # download_message, acknowledge_message
          end

          operations = Operation.order(created_at: :asc)
          expect(operations.map(&:action)).to eq(%w(download_message acknowledge_message))
          expect(operations.map(&:transmission_id).uniq).to eq([nil])
          download_operation = operations[0]
          expect(download_operation).to have_attributes(
            parent_id: nil,
            transmission_id: nil,
            mesh_error: true,
            mesh_response_error_event: nil,
            mesh_response_error_code: "14",
            mesh_response_error_description: "Undelivered message",
            reconciliation_error: true,
            reconciliation_error_description: "No corresponding send_message operation found " \
                                              "for downloaded message #{message_id}"
          )
        end
        # rubocop:enable RSpec/ExampleLength
      end
    end
  end
end
