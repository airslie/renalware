# frozen_string_literal: true

module Renalware::Letters::Transports::Mesh
  describe API::ResponseHeaders do
    subject(:response_headers) { described_class.new(http_headers) }

    let(:http_headers) do
      {
        "Mex-StatusEvent" => "STATUS_EVENT",
        "Mex-LinkedMsgID" => "LINKED_MSG_ID",
        "Mex-WorkflowID" => "WORKFLOW_ID",
        "Mex-StatusTimestamp" => "STATUS_TIMESTAMP",
        "Mex-LocalID" => "LOCAL_ID",
        "Mex-StatusCode" => "STATUS_CODE",
        "Mex-MessageID" => "MESSAGE_ID",
        "Mex-StatusSuccess" => "STATUS_SUCCESS",
        "Mex-StatusDescription" => "STATUS_DESCRIPTION",
        "Mex-To" => "TO",
        "Mex-MessageType" => "MESSAGE_TYPE",
        "Mex-Subject" => "SUBJECT"
      }
    end

    describe "dyanamic methods for grabbing Mex-* header content" do
      %i(
        status_event
        linked_msg_id
        workflow_id
        status_timestamp
        local_id
        status_code
        message_id
        status_success
        status_description
        to
        message_type
        subject
      ).each do |method_name|
        it method_name.to_s do
          expect(response_headers.send(method_name)).to eq(method_name.to_s.upcase)
        end
      end
    end

    describe "#error_report?" do
      subject { response_headers.error_report? }

      context "when Mex-MessageType == DATA" do
        let(:http_headers) { { "Mex-MessageType" => "DATA" } }

        it { is_expected.to be(false) }
      end

      context "when Mex-MessageType == REPORT" do
        let(:http_headers) { { "Mex-MessageType" => "REPORT" } }

        it { is_expected.to be(true) }
      end
    end
  end
end
