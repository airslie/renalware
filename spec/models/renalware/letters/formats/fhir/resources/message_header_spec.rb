module Renalware
  module Letters
    module Formats
      module FHIR
        describe Resources::MessageHeader do
          subject(:message_header) { described_class.call(arguments) }

          let(:transmission) { instance_double(Transports::Mesh::Transmission, letter: letter) }
          let(:patient) { Renalware::Patient.new(secure_id: "456") }
          let(:topic) { build(:letter_topic, snomed_document_type: build(:snomed_document_type)) }
          let(:letter) { instance_double(Letter, patient: patient, uuid: "789", topic: topic) }
          let(:arguments) do
            Arguments.new(
              transmission: transmission,
              transaction_uuid: "123",
              organisation_uuid: "ORG1",
              itk_organisation_uuid: "ITKORG1"
            )
          end

          context "when workflow is :gp_connect" do
            before do
              allow(Renalware.config).to receive(:letters_mesh_workflow).and_return(:gp_connect)
            end

            it "resolves the correct workflow id to use in HTTP headers etc" do
              allow(Renalware.config).to receive(:letters_mesh_workflow).and_return(:gp_connect)
              expect(Renalware.config.mesh_workflow_id).to eq("GPCONNECT_SEND_DOCUMENT")
            end

            describe "#resource" do
              subject(:resource) { message_header[:resource] }

              describe "ITK-MessageHeader-2 extension" do
                # GPCM-SD-040
                it "BusAckRequested is true" do
                  extension = resource.extension[0].extension[0]
                  expect(extension.url).to eq("BusAckRequested")
                  expect(extension.valueBoolean).to be(true)
                end

                # GPCM-SD-041
                it "InfAckRequested is true" do
                  extension = resource.extension[0].extension[1]
                  expect(extension.url).to eq("InfAckRequested")
                  expect(extension.valueBoolean).to be(true)
                end

                # GPCM-SD-043
                it "MessageDefinition url is correct" do
                  extension = resource.extension[0].extension[3]
                  expect(extension.url).to eq("MessageDefinition")
                  expect(extension.valueReference.reference).to eq(
                    "https://fhir.nhs.uk/STU3/MessageDefinition/ITK-GPConnectSendDocument-MessageDefinition-1"
                  )
                end

                # GPCM-SD-042
                it "SenderReference is a uuid identifying the activity ie letter" do
                  extension = resource.extension[0].extension[4]
                  expect(extension.url).to eq("SenderReference")
                  expect(extension.valueString).to eq("urn:uuid:#{letter.uuid}")
                  expect(extension.valueString).to eq("urn:uuid:789")
                end

                # GPCM-SD-044
                it "LocalExtension is NONE" do
                  extension = resource.extension[0].extension[5]
                  expect(extension.url).to eq("LocalExtension")
                  expect(extension.valueString).to eq("None")
                end
              end

              it "has a timestamp" do
                freeze_time do
                  expect(resource.timestamp).to eq(Time.zone.now.iso8601)
                end
              end

              it "has an event describing the message" do
                coding = resource.event.first
                expect(coding.code).to eq("ITK007C") # ITK3-MessageEvent
                expect(coding.display).to eq("ITK GP Connect Send Document")
              end

              # GPCM-SD-046
              it "source specifies our mailbox id" do
                allow(Renalware.config).to receive(:mesh_mailbox_id).and_return("ABC123")
                expect(resource.source.endpoint).to eq("ABC123")
              end
            end
          end

          context "when workflow is :transfer_of_care" do
            before do
              allow(Renalware.config)
                .to receive(:letters_mesh_workflow)
                .and_return(:transfer_of_care)
            end

            # it "resolves the correct workflow id to use in HTTP headers etc" do
            #   expect(Renalware.config.mesh_workflow_id).to eq("d")
            # end

            describe "#resource" do
              subject(:resource) { message_header[:resource] }

              it "has an event describing the message" do
                coding = resource.event.first
                expect(coding.code).to eq("ITK006D")
                expect(coding.display).to eq("ITK Outpatient Letter")
              end

              it "MessageDefinition url is correct" do
                extension = resource.extension[0].extension[3]
                expect(extension.url).to eq("MessageDefinition")
                expect(extension.valueReference.reference).to eq(
                  "https://fhir.nhs.uk/STU3/MessageDefinition/ITK-OPL-MessageDefinition-4"
                )
              end
            end
          end
        end
      end
    end
  end
end
