# frozen_string_literal: true

require_relative "../../support/message_spec_helper"

module Renalware::Letters::Transports::Mesh
  describe API::ResponseHandlers::MeshResponseHandler do
    include LettersSpecHelper
    include MeshSpecHelper
    include FaradayHelper

    let(:user) { create(:user) }

    describe "#call" do
      context "when there is no message object because its a handshake, check_inbox etc" do
        context "when there is no error in the json" do
          it "does nothing" do
            response = mock_faraday_response(body: {})

            expect {
              described_class.call(response)
            }.not_to raise_error
          end
        end

        context "when there is an error in the json" do
          it "raise an error" do
            response = mock_faraday_response(
              body: {
                "errorEvent" => "SEND",
                "errorCode" => "EPL-151",
                "errorDescription" => "No mailbox matched"
              }
            )

            expect {
              described_class.call(response)
            }.to raise_error(API::Errors::MeshMailboxOrNHSNumberException)
          end
        end
      end

      context "when there is a message object because its a send_message etc" do
        let(:message) do
          Message.create!(
            letter: create_mesh_letter(
              patient: create_mesh_patient(user: user),
              user: user
            )
          )
        end

        context "when there is no error in the json" do
          it "does nothing" do
            response = mock_faraday_response(body: {})

            expect {
              described_class.new(message: message).call(response)
            }.not_to raise_error

            expect(message).to have_attributes(
              mesh_response_error_code: nil,
              mesh_response_error_description: nil,
              mesh_response_error_event: nil
            )
          end
        end

        context "when there is an error in the json" do
          it "raise an error" do
            response = mock_faraday_response(
              body: {
                "errorEvent" => "SEND",
                "errorCode" => "EPL-151",
                "errorDescription" => "No mailbox matched"
              }
            )

            expect {
              described_class.new(message: message).call(response)
            }.to raise_error(API::Errors::MeshMailboxOrNHSNumberException)

            expect(message.reload).to have_attributes(
              mesh_response_error_event: "SEND",
              mesh_response_error_code: "EPL-151",
              mesh_response_error_description: "No mailbox matched"
            )
          end
        end
      end
    end
  end
end
