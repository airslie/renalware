# frozen_string_literal: true

require_relative "../../support/message_spec_helper"

module Renalware::Letters::Transports::Mesh
  describe API::ResponseHandlers::HttpResponseHandler do
    include LettersSpecHelper
    include MeshSpecHelper
    include FaradayHelper

    let(:user) { create(:user) }

    describe "support for proc composition" do # shared example?
      it { is_expected.to respond_to(:call) }
      it { is_expected.to respond_to(:<<) }
      it { is_expected.to respond_to(:>>) }
    end

    context "when no message is supplied eg its a handshake or check_inbox api call" do
      context "when the http status indicates success" do
        [100, 200, 201].each do |http_status|
          it "does nothing" do
            response = mock_faraday_response(status: http_status, body: {})
            expect {
              described_class.call(response)
            }.not_to raise_error
          end
        end
      end

      context "when the http status indicates an error" do
        {
          400 => API::Errors::BadRequestError,
          403 => API::Errors::AuthorizationError,
          404 => API::Errors::MessageDoesNotExistError,
          410 => API::Errors::MessageAlreadyDownloadedAndAcknowledgedError,
          417 => API::Errors::InvalidRecipientOrWorkflowRestrictedError,
          300 => API::Errors::UnrecognisedHttpResponseCodeError,
          399 => API::Errors::UnrecognisedHttpResponseCodeError
        }.each do |http_status, error|
          it "raises #{error} when http status is #{http_status}" do
            response = mock_faraday_response(status: http_status, body: "")
            expect {
              described_class.call(response)
            }.to raise_error(error)
          end
        end
      end
    end

    context "when a message is supplied eg its a send_message or download_message api call" do
      let(:message) do
        Message.create!(
          letter: create_mesh_letter(
            patient: create_mesh_patient(user: user),
            user: user
          )
        )
      end

      context "when the http status indicates success" do
        [100, 200, 201].each do |http_status|
          it "does nothing" do
            response = mock_faraday_response(status: http_status, body: "{}")
            expect {
              described_class.new(message: message).call(response)
            }.not_to raise_error

            expect(message.reload).to have_attributes(
              http_response_code: http_status.to_s,
              http_response_description: nil
            )
          end
        end
      end

      context "when the http status indicates an error" do
        {
          400 => API::Errors::BadRequestError,
          403 => API::Errors::AuthorizationError,
          404 => API::Errors::MessageDoesNotExistError,
          410 => API::Errors::MessageAlreadyDownloadedAndAcknowledgedError,
          417 => API::Errors::InvalidRecipientOrWorkflowRestrictedError,
          300 => API::Errors::UnrecognisedHttpResponseCodeError,
          399 => API::Errors::UnrecognisedHttpResponseCodeError
        }.each do |http_status, error|
          it "raises #{error} when http status is #{http_status}" do
            response = mock_faraday_response(status: http_status, body: "")

            described_class.new(message: message).call(response)

            expect(message.reload).to have_attributes(
              http_response_code: http_status.to_s
            )
          end
        end
      end
    end
  end
end
