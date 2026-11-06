RSpec.describe Relay::GPConnect::Mesh::ITK3Response do
  def xml_for(detail_code: "10001")
    <<~XML
      <!-- Simplified! -->
      <Bundle>
        <entry>
          <resource>
            <MessageHeader>
              <response>
                <code value="fatal-error"
              </response>
            </MessageHeader>
          </resource>
        </entry>
        <entry>
          <resource>
            <OperationOutcome>
              <issue>
                <severity value="fatal"/>
                <code value="processing"/>
                <details>
                  <coding>
                    <code value="#{detail_code}"/>
                    <display value="Handling Specification Error"/>
                  </coding>
                </details>
              </issue>
            </OperationOutcome>
          </resource>
        </entry>
      </Bundle>
    XML
  end

  def itk3_response(detail_code: "10001", headers: {})
    described_class.new(mock_faraday_response(body: xml_for(detail_code:), headers:))
  end

  it "raises an error if response headers are empty" do
    expect { itk3_response.handleable? }.to raise_error(ArgumentError)
  end

  it "reads the details of the response" do
    response = itk3_response

    expect(response.response_code).to eq("fatal-error")
    expect(response.issue_code).to eq("processing")
    expect(response.detail_code).to eq("10001")
    expect(response.detail_description).to eq("Handling Specification Error")
    expect(response.issue_severity).to eq("fatal")
  end

  # Infrastructure response codes start with 1 or 2, business response codes with 3.
  { "10001" => true, "20001" => true, "30001" => false }.each do |code, infrastructure|
    kind = infrastructure ? "infrastructure" : "business"

    it "classifies a #{code} response as #{kind}" do
      response = itk3_response(detail_code: code)

      expect(response.infrastructure?).to be(infrastructure)
      expect(response.business?).to be(!infrastructure)
    end
  end

  it "is handleable when the content type is xml or octet-stream" do
    xml = { "Content-Type" => "application/xml" }
    octet = { "Content-Type" => "application/octet-stream" }
    json = { "Content-Type" => "application/json" }

    expect(itk3_response(headers: xml)).to be_handleable
    expect(itk3_response(headers: octet)).to be_handleable
    expect(itk3_response(headers: json)).not_to be_handleable
  end
end
