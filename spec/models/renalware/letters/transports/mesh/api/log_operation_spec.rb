module Renalware::Letters::Transports::Mesh
  # Characterisation of how every MESH API call is recorded: an Operation row is created, the block
  # makes the call, and the response is parsed into the operation's columns.
  describe API::LogOperation do
    include LettersSpecHelper
    include MeshSpecHelper

    let(:json) { { "Content-Type" => "application/json" } }
    let(:xml) { { "Content-Type" => "application/xml" } }
    let(:itk3_xml) do
      <<~XML
        <Bundle>
          <entry><resource><MessageHeader><response>
            <code value="ok"/>
            <identifier value="the-send-operation-uuid"/>
          </response></MessageHeader></resource></entry>
          <entry><resource><OperationOutcome><issue>
            <severity value="information"/>
            <code value="informational"/>
            <details><coding><code value="30001"/><display value="Business ack"/></coding></details>
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

    it "creates an operation, yields it to the block and returns the block's response" do
      response = faraday_response(body: '{"mailboxId":"MB1"}', headers: json)
      yielded = nil

      returned = described_class.call(:handshake) { |operation| (yielded = operation) && response }

      expect(returned).to equal(response)
      expect(yielded).to be_persisted
      expect(yielded).to have_attributes(action: "handshake", direction: "outbound")
      expect(yielded.uuid).to be_present
    end

    it "stores any extra attributes given, such as the transmission or MESH message id" do
      transmission = Transmission.create!(letter: create_letter_for_log_operation)

      operation = nil
      described_class.call(:send_message, transmission_id: transmission.id,
                                          mesh_message_id: "M1") do |op|
        operation = op
        nil
      end

      expect(operation.reload).to have_attributes(transmission_id: transmission.id,
                                                  mesh_message_id: "M1")
    end

    it "returns nil, leaving just the initial operation, when there is no block" do
      expect(described_class.call(:handshake)).to be_nil
      expect(Operation.last).to have_attributes(action: "handshake", http_response_code: nil)
    end

    it "returns nil, leaving just the initial operation, when the block returns nil" do
      expect(described_class.call(:handshake) { nil }).to be_nil
      expect(Operation.last).to have_attributes(action: "handshake", http_response_code: nil)
    end

    it "records a successful json response" do
      response = faraday_response(body: '{"messageID":"MSG1"}', headers: json, status: 202)

      described_class.call(:send_message) { response }

      expect(Operation.last).to have_attributes(
        http_response_code: 202,
        http_error: false,
        mesh_error: false,
        mesh_response_error_code: nil,
        itk3_response_type: nil,
        itk3_error: false,
        mesh_message_id: "MSG1"
      )
    end

    it "records an http error status (300 and above) as an http_error" do
      response = faraday_response(body: '{"errorDescription":"x"}', headers: json, status: 300)

      described_class.call(:send_message) { response }

      expect(Operation.last).to have_attributes(http_response_code: 300, http_error: true)
    end

    it "records a MESH error returned in a json body" do
      body = '{"errorEvent":"SEND","errorCode":"EPL-151","errorDescription":"No mailbox matched"}'
      response = faraday_response(body:, headers: json, status: 403)

      described_class.call(:handshake) { response }

      expect(Operation.last).to have_attributes(
        http_response_code: 403,
        http_error: true,
        mesh_error: true,
        mesh_response_error_event: "SEND",
        mesh_response_error_code: "EPL-151",
        mesh_response_error_description: "No mailbox matched"
      )
    end

    it "records a MESH error report with no body from the Mex-* response headers" do
      headers = {
        "Content-Type" => "text/plain",
        "Mex-MessageType" => "REPORT",
        "Mex-StatusCode" => "14",
        "Mex-StatusDescription" => "Undelivered message"
      }
      response = faraday_response(body: "", headers:)

      described_class.call(:download_message) { response }

      expect(Operation.last).to have_attributes(
        mesh_error: true,
        mesh_response_error_event: nil,
        mesh_response_error_code: "14",
        mesh_response_error_description: "Undelivered message"
      )
    end

    it "treats a non-report, non-json response as having no MESH error" do
      response = faraday_response(body: itk3_xml, headers: xml.merge("Mex-MessageType" => "DATA"))

      described_class.call(:download_message) { response }

      expect(Operation.last).to have_attributes(mesh_error: false, mesh_response_error_code: nil)
    end

    it "records the ITK3 response details from an xml response" do
      response = faraday_response(body: itk3_xml, headers: xml)

      described_class.call(:download_message) { response }

      expect(Operation.last).to have_attributes(
        itk3_response_type: "bus",
        itk3_response_code: "ok",
        itk3_operation_outcome_type: "informational",
        itk3_operation_outcome_severity: "information",
        itk3_operation_outcome_code: "30001",
        itk3_operation_outcome_description: "Business ack",
        itk3_error: false
      )
    end

    it "stores the request and response headers" do
      response = faraday_response(body: '{"mailboxId":"MB1"}', headers: json.merge("X-Test" => "1"))

      described_class.call(:handshake) { response }

      expect(Operation.last).to have_attributes(
        request_headers: hash_including("Mex-From" => "ME"),
        response_headers: hash_including("Content-Type" => "application/json", "X-Test" => "1")
      )
    end

    # NB the raw body is assigned and then immediately overwritten by the parsed body, so a json
    # response is stored as the string form of the parsed Hash. Pinned as is.
    it "stores a json response body as the string form of the parsed body" do
      response = faraday_response(body: '{"messages":[]}', headers: json)

      described_class.call(:check_inbox) { response }

      expect(Operation.last.response_body).to eq({ "messages" => [] }.to_s)
    end

    it "stores an xml response body as is" do
      response = faraday_response(body: itk3_xml, headers: xml)

      described_class.call(:download_message) { response }

      expect(Operation.last.response_body).to eq(itk3_xml)
    end

    it "does not overwrite a MESH message id that was already set" do
      response = faraday_response(body: '{"messageID":"FROM_BODY"}', headers: json)

      described_class.call(:send_message, mesh_message_id: "ALREADY") { response }

      expect(Operation.last.mesh_message_id).to eq("ALREADY")
    end

    it "records an unexpected error on the operation and re-raises it" do
      expect { failing_call }.to raise_error(ArgumentError, "boom")

      expect(Operation.last.unhandled_error).to include("boom")
    end

    def failing_call
      described_class.call(:handshake) { raise ArgumentError, "boom" }
    end

    def create_letter_for_log_operation
      user = create(:user)
      create_mesh_letter_to_gp(create_mesh_patient(user:), user)
    end
  end
end
