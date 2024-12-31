module Renalware::Letters
  module Transports::Mesh
    describe SendMessageJob do
      include FaradayHelper
      include LettersSpecHelper
      include MeshSpecHelper

      let(:transmission) { Transmission.create!(letter: letter) }
      let(:user) { create(:user) }
      let(:topic) { build(:letter_topic, snomed_document_type: build(:snomed_document_type)) }
      let(:letter) do
        create_mesh_letter_to_gp(
          create_mesh_patient(user: user),
          user
        )
      end

      describe "the happy path" do
        it "creates FHIR XML payload, and sends to the API client, stores the returned msg id" do
          letter.patient.practice.update!(mesh_mailbox_id: "test_mailbox_id")

          allow(Formats::FHIR::BuildPayload).to receive(:call).and_return("PAYLOAD")
          response = mock_faraday_response(
            body: JSON.parse('{"messageId": "123"}'),
            raw_body: '{"messageId": "123"}'
          )
          allow(API::Client)
            .to receive(:send_message)
            .and_return(response)

          expect do
            described_class.new.perform(transmission)
          end.to change(Operation, :count).by(1)

          expect(Formats::FHIR::BuildPayload).to have_received(:call)
          expect(API::Client).to have_received(:send_message)
          expect(Operation.first).to have_attributes(
            transmission_id: transmission.id,
            action: "send_message"
          )
        end
      end

      context "when the gp is not a recipient" do
        it "does not send anything" do
          letter = create_mesh_letter(
            patient: create_mesh_patient(user: user),
            user: user,
            to: :patient
          )
          transmission = Transmission.create!(letter: letter)

          # recipients sanity check
          expect(letter.recipients.length).to eq(1)
          expect(letter.recipients.first).to be_patient

          expect {
            described_class.new.perform(transmission)
          }.to raise_error(SendMessageJob::GPNotInRecipientsError)
        end
      end

      context "when the gp is a recipient but the practice is nil" do
        it "does not send anything" do
          letter.patient.update!(practice_id: nil, by: user)
          transmission = Transmission.create!(letter: letter)

          expect {
            described_class.new.perform(transmission)
          }.to raise_error(SendMessageJob::PatientHasNoPracticeError)
        end
      end

      context "when the gp is a recipient but practice mesh mailbox is missing" do
        it "does not send anything" do
          letter.patient.practice.update!(mesh_mailbox_id: "")
          transmission = Transmission.create!(letter: letter)

          pending "FIXME"

          expect do
            described_class.new.perform(transmission)
          end.not_to change(Operation, :count)
        end
      end
    end
  end
end
