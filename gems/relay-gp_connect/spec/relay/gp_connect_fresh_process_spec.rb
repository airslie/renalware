require "open3"
require "rbconfig"

# The rest of this suite runs with vcr, webmock and Active Support's test helpers loaded, which
# pull in `uri`, date extensions and so on as a side effect. That can hide a require the gem itself
# is missing. These examples run the gem in a brand new Ruby process that loads nothing except
# `relay/gp_connect`, as a real caller would.
RSpec.describe Relay::GPConnect do
  context "when loaded in a fresh Ruby process" do
    let(:lib) { File.expand_path("../../lib", __dir__) }
    let(:request_helper) { File.expand_path("../support/delivery_request_helper.rb", __dir__) }
    let(:fixtures) { File.expand_path("../fixtures", __dir__) }

    # Runs the script with only the gem on the load path. Returns [stdout, stderr, success?].
    def run_fresh(script)
      stdout, stderr, status = Open3.capture3(RbConfig.ruby, "-I", lib, "-e", script)
      [stdout, stderr, status.success?]
    end

    it "builds a GP Connect payload" do
      script = <<~RUBY
        require "relay/gp_connect"
        require #{request_helper.inspect}
        include DeliveryRequestHelper

        arguments = Relay::GPConnect::FHIR::Arguments.new(
          request: plain_delivery_request, transmission_uuid: "t", transaction_uuid: "x"
        )
        xml = Relay::GPConnect::FHIR::BuildPayload.call(arguments)
        # The composition date is formatted with an Active Support extension (DateTime#utc), which
        # gives "...Z" rather than "...+00:00", so check the date as well as that a Bundle came out.
        ok = xml.include?("<Bundle") && xml.include?('<date value="2022-01-01T01:01:01Z"/>')
        puts ok ? "built" : "wrong output"
      RUBY

      stdout, stderr, success = run_fresh(script)

      expect([success, stdout.strip, stderr]).to eq([true, "built", ""])
    end

    it "builds the MESH headers, certificates and operation attributes" do
      script = <<~RUBY
        require "relay/gp_connect"
        require "faraday"
        require "tmpdir"

        Mesh = Relay::GPConnect::Mesh
        cert = File.join(#{fixtures.inspect}, "dummy_mesh_cert.txt")
        key = File.join(#{fixtures.inspect}, "dummy_mesh_key.txt")
        config = Mesh::Config.new(
          mailbox_id: "MB1", mailbox_password: "p", api_secret: "s", api_base_url: "https://x/y",
          workflow_id: "WF", client_cert_path: cert, client_cert: nil, client_key_path: key,
          client_key: nil, ca_file_path: File.join(Dir.mktmpdir, "ca.pem"), ca_cert: File.read(cert),
          base_dir: Pathname(Dir.tmpdir)
        )

        headers = Mesh::RequestHeaders.new(config:, to: "abc", subject: "s").to_h
        certificates = Mesh::Certificates.new(config:)
        certificates.client_cert
        certificates.client_key
        certificates.ca_file_path

        stubs = Faraday::Adapter::Test::Stubs.new do |stub|
          stub.get("/x") { [200, { "Content-Type" => "application/json" }, '{"messageID":"M1"}'] }
        end
        response = Faraday.new { |f| f.response :json; f.adapter :test, stubs }.get("/x")
        attributes = Mesh::OperationAttributes.new(response)
        attributes.to_h
        Mesh::ResponseHeaders.new("Mex-MessageType" => "REPORT").error_report?

        Relay::GPConnect.loader.eager_load
        puts [headers["Mex-From"], attributes.message_id].join(",")
      RUBY

      stdout, stderr, success = run_fresh(script)

      expect([success, stdout.strip, stderr]).to eq([true, "MB1,M1", ""])
    end
  end
end
