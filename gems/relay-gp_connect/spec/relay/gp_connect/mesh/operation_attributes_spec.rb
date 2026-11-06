# The pure part of recording an API call: turning a response into the attributes describing it.
# No database; this is what any user of the MESH client (e.g. Relay) can share, and then store
# however it likes.
RSpec.describe Relay::GPConnect::Mesh::OperationAttributes do
  let(:json) { { "Content-Type" => "application/json" } }
  let(:xml) { { "Content-Type" => "application/xml" } }
  let(:itk3_xml) do
    <<~XML
      <Bundle>
        <entry><resource><MessageHeader><response>
          <code value="fatal-error"/>
        </response></MessageHeader></resource></entry>
        <entry><resource><OperationOutcome><issue>
          <severity value="fatal"/>
          <code value="processing"/>
          <details><coding><code value="10001"/><display value="Handling error"/></coding></details>
        </issue></OperationOutcome></resource></entry>
      </Bundle>
    XML
  end

  def faraday_response(body:, headers:, status: 200)
    stubs = Faraday::Adapter::Test::Stubs.new { |stub| stub.get("/x") { [status, headers, body] } }
    connection = Faraday.new(headers: { "Mex-From" => "ME" }) do |f|
      f.response :json, preserve_raw: true
      f.adapter :test, stubs
    end
    connection.get("/x")
  end

  def attributes_for(**) = described_class.new(faraday_response(**)).to_h

  it "describes the http response" do
    expect(attributes_for(body: "{}", headers: json, status: 202))
      .to include(http_response_code: 202, http_error: false)
    expect(attributes_for(body: "{}", headers: json, status: 299)).to include(http_error: false)
    expect(attributes_for(body: "{}", headers: json, status: 300)).to include(http_error: true)
  end

  it "takes a MESH error from a json body" do
    body = '{"errorEvent":"SEND","errorCode":"EPL-151","errorDescription":"No mailbox matched"}'

    expect(attributes_for(body:, headers: json, status: 403)).to include(
      mesh_error: true,
      mesh_response_error_event: "SEND",
      mesh_response_error_code: "EPL-151",
      mesh_response_error_description: "No mailbox matched"
    )
  end

  it "has no MESH error for a json body without an errorDescription" do
    expect(attributes_for(body: '{"mailboxId":"MB1"}', headers: json)).to include(
      mesh_error: false, mesh_response_error_code: nil
    )
  end

  it "takes a MESH error report from the Mex-* headers when there is no json body" do
    headers = {
      "Content-Type" => "text/plain",
      "Mex-MessageType" => "REPORT",
      "Mex-StatusCode" => "14",
      "Mex-StatusDescription" => "Undelivered message"
    }

    expect(attributes_for(body: "", headers:)).to include(
      mesh_error: true,
      mesh_response_error_event: nil,
      mesh_response_error_code: "14",
      mesh_response_error_description: "Undelivered message"
    )
  end

  it "matches Mex-* headers case-insensitively" do
    headers = {
      "Content-Type" => "text/plain", "mex-messagetype" => "REPORT", "mex-statuscode" => "9"
    }

    expect(attributes_for(body: "", headers:))
      .to include(mesh_error: true, mesh_response_error_code: "9")
  end

  it "includes the ITK3 details of an xml response" do
    expect(attributes_for(body: itk3_xml, headers: xml)).to include(
      itk3_response_type: :inf,
      itk3_response_code: "fatal-error",
      itk3_operation_outcome_type: "processing",
      itk3_operation_outcome_severity: "fatal",
      itk3_operation_outcome_code: "10001",
      itk3_operation_outcome_description: "Handling error",
      itk3_error: true
    )
  end

  it "has no ITK3 details for a json response" do
    expect(attributes_for(body: "{}", headers: json).keys).not_to include(:itk3_response_type)
  end

  it "includes the request and response headers" do
    attributes = attributes_for(body: "{}", headers: json.merge("X-Test" => "1"))

    expect(attributes[:request_headers]).to include("Mex-From" => "ME")
    expect(attributes[:response_headers]).to include("X-Test" => "1")
  end

  it "includes the parsed response body" do
    expect(attributes_for(body: '{"messages":[]}', headers: json))
      .to include(response_body: { "messages" => [] })
    expect(attributes_for(body: itk3_xml, headers: xml)).to include(response_body: itk3_xml)
  end

  it "exposes the MESH message id from a json body, separately from #to_h" do
    response = faraday_response(body: '{"messageID":"MSG1"}', headers: json)

    expect(described_class.new(response).message_id).to eq("MSG1")
    expect(described_class.new(response).to_h.keys).not_to include(:mesh_message_id)
  end
end
