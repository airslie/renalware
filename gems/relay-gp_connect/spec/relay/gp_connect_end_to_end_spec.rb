# The steps in the README: describe what to send, build the message, send it. A recorded MESH
# response (VCR) stands in for MESH; the point is that the pieces fit together with nothing but
# plain values and a Mesh::Config.
RSpec.describe Relay::GPConnect do
  it "builds a GP Connect message from a DeliveryRequest and sends it with the MESH client" do
    request = plain_delivery_request
    arguments = Relay::GPConnect::FHIR::Arguments.new(
      request:,
      transmission_uuid: SecureRandom.uuid,
      transaction_uuid: SecureRandom.uuid
    )
    xml = Relay::GPConnect::FHIR::BuildPayload.call(arguments)

    response = VCR.use_cassette("mesh/send_message/naive") do
      Relay::GPConnect::Mesh::Client.new(config: build_mesh_config).send_message(
        xml,
        operation_uuid: SecureRandom.uuid,
        to: arguments.mex_to,
        subject: arguments.mex_subject
      )
    end

    expect(xml).to include("<Bundle")
    expect(response.status).to eq(202)
    expect(WebMock).to(have_requested(:post, %r{/RAJ01OT001/outbox}).with { |sent|
      sent.headers["Mex-To"] == "GPPROVIDER_9999999999_19700102_Jones" &&
        sent.headers["Mex-Subject"].start_with?("Consultation report for JONES, Patricia") &&
        sent.body.include?("urn:uuid:11111111-1111-1111-1111-111111111111")
    })
  end

  it "records what the response says as plain attributes for the host to store" do
    response = VCR.use_cassette("mesh/send_message/naive") do
      Relay::GPConnect::Mesh::Client.new(config: build_mesh_config)
        .send_message("<Bundle/>", operation_uuid: "x", to: "abc", subject: "xyz")
    end

    attributes = Relay::GPConnect::Mesh::OperationAttributes.new(response)

    expect(attributes.to_h).to include(http_response_code: 202, http_error: false,
                                       mesh_error: false)
    expect(attributes.message_id).to eq("DC15F15F29D5487EA444310EE5222322")
  end
end
