# Not too sure what we are testing here as we could end up testing the NHS MESH docker sandbox
# rather than our app! Validating various VCR cassettes is useful however
# (a MESH sandbox can be run on localhost:8700 with docker: https://github.com/NHSDigital/mesh-sandbox)
RSpec.describe Relay::GPConnect::Mesh::Client do
  subject(:client) { described_class.new(config:) }

  let(:mesh_mailbox_id) { "RAJ01OT001" }
  let(:config) { build_mesh_config(mailbox_id: mesh_mailbox_id) }

  def cassette(path) = File.join("mesh", path)

  it "requires a config" do
    expect { described_class.new }.to raise_error(ArgumentError, /config/)
  end

  # What we hand to Faraday: the mailbox url, the Mex-* headers and the TLS options.
  it "builds its connection from the mailbox url, request headers and client certificates" do
    allow(Faraday).to receive(:new).and_call_original

    VCR.use_cassette(cassette("handshake/success")) { client.handshake }

    expect(Faraday).to have_received(:new).with(
      hash_including(
        url: "#{config.api_base_url}/#{mesh_mailbox_id}",
        headers: hash_including(
          "Mex-From" => mesh_mailbox_id,
          "Mex-WorkflowID" => "GPCONNECT_SEND_DOCUMENT",
          "Content-Type" => "application/xml"
        ),
        ssl: hash_including(
          ca_file: config.ca_file_path,
          client_cert: an_instance_of(OpenSSL::X509::Certificate),
          client_key: an_instance_of(OpenSSL::PKey::RSA)
        )
      )
    )
  end

  # CURRENT BEHAVIOUR, pinned so that refactoring cannot change it unnoticed. The NHS MESH
  # endpoints use a private CA, and verification is currently off. Turning it on is a
  # deliberate, separately tested change; when you do it, update this example.
  it "currently does not verify the server certificate (verify: false)" do
    allow(Faraday).to receive(:new).and_call_original

    VCR.use_cassette(cassette("handshake/success")) { client.handshake }

    expect(Faraday)
      .to have_received(:new).with(hash_including(ssl: hash_including(verify: false)))
  end

  it "handshake returns a 403 and an EPL error when the mailbox does not exist" do
    bad = described_class.new(config: build_mesh_config(mailbox_id: "BADMAILBOX"))

    response = VCR.use_cassette(cassette("handshake/mailbox_not_found")) { bad.handshake }

    expect(response.status).to eq(403)
    expect(response.body).to include("errorCode" => "EPL-151")
  end

  it "handshake returns the mailbox id when the mailbox exists" do
    response = VCR.use_cassette(cassette("handshake/success")) { client.handshake }

    expect(response.status).to eq(200)
    expect(response.body).to eq("mailboxId" => mesh_mailbox_id)
  end

  it "check_inbox returns the waiting messages" do
    response = VCR.use_cassette(cassette("check_inbox/no_messages")) { client.check_inbox }

    expect(response.status).to eq(200)
    expect(response.body).to eq("messages" => [])
  end

  it "download_message returns 404 when the message does not exist" do
    response = VCR.use_cassette(cassette("download_message/not_found")) do
      client.download_message("123")
    end

    expect(response.status).to eq(404)
    expect(response.body).to include("errorDescription" => "Message does not exist")
  end

  it "download_message returns a REPORT message with no body" do
    response = VCR.use_cassette(cassette("download_message/report/undelivered")) do
      client.download_message("123")
    end

    expect(response.status).to eq(200)
    expect(response.body).to be_blank
    expect(response.headers["Mex-MessageType"]).to eq("REPORT")
    expect(response.headers["Mex-StatusCode"]).to eq("14")
    expect(response.headers["Mex-StatusDescription"]).to eq("Undelivered message")
  end

  it "download_message downloads a simple message created with curl!" do
    response = VCR.use_cassette(cassette("download_message/60A7BB96B4974B5D8CD50E28CB782795")) do
      client.download_message("60A7BB96B4974B5D8CD50E28CB782795")
    end

    expect(response.status).to eq(200)
    expect(response.body).to eq("This is a message")
  end

  it "send_message sends a simple empty Bundle XML message" do
    response = VCR.use_cassette(cassette("send_message/naive")) do
      client.send_message(
        '<Bundle xmlns="http://hl7.org/fhir"></Bundle>',
        operation_uuid: "localID",
        to: "abc",
        subject: "xyz"
      )
    end

    expect(response.status).to eq(202)
    expect(response.body).to eq("messageID" => "DC15F15F29D5487EA444310EE5222322")
  end

  it "send_message refuses to send without a Mex-To or Mex-Subject" do
    expect { client.send_message("<x/>", subject: "xyz") }
      .to raise_error(ArgumentError, "Missing Mex-To")
    expect { client.send_message("<x/>", to: "abc") }
      .to raise_error(ArgumentError, "Missing Mex-Subject")
  end
end
