RSpec.describe Relay::GPConnect::Mesh::ResponseHeaders do
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

  # Mex-* headers are reified into methods, e.g. #status_description => "Mex-StatusDescription"
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
    it "reads the Mex-* header as ##{method_name}" do
      expect(response_headers.public_send(method_name)).to eq(method_name.to_s.upcase)
    end
  end

  it "is an error report when Mex-MessageType is REPORT" do
    expect(described_class.new("Mex-MessageType" => "REPORT")).to be_error_report
  end

  it "is not an error report when Mex-MessageType is DATA" do
    expect(described_class.new("Mex-MessageType" => "DATA")).not_to be_error_report
  end

  it "can return the headers as a hash" do
    expect(response_headers.to_h).to eq(http_headers)
  end
end
