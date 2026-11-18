# Characterisation ("golden file") spec for the GP Connect Send Document payload.
#
# The XML produced here is what NHS England assured and what is in production, so any change to
# this gem must leave it byte-for-byte unchanged. All inputs are fixed and the two sources of
# nondeterminism (the MessageHeader timestamp and random identifiers) are pinned.
#
# If a change to the payload is intentional (and re-assured), regenerate the fixture with:
#   UPDATE_GOLDEN=1 bundle exec rspec spec/relay/gp_connect/fhir/build_payload_spec.rb
RSpec.describe Relay::GPConnect::FHIR::BuildPayload do
  let(:fixture_path) { File.expand_path("../../../fixtures/gp_connect_send_document.xml", __dir__) }
  let(:request_class) { Relay::GPConnect::DeliveryRequest }
  let(:arguments_class) { Relay::GPConnect::FHIR::Arguments }

  def args_for(request = plain_delivery_request)
    arguments_class.new(
      request:,
      transmission_uuid: "66666666-6666-6666-6666-666666666666",
      transaction_uuid: "77777777-7777-7777-7777-777777777777"
    )
  end

  before do
    allow(SecureRandom).to receive(:uuid).and_return("aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa")
  end

  it "produces the assured GP Connect XML, unchanged" do
    xml = travel_to(Time.utc(2022, 1, 2, 3, 4, 5)) { described_class.call(args_for) }

    File.write(fixture_path, xml) if ENV["UPDATE_GOLDEN"]

    expect(xml).to eq(File.read(fixture_path))
  end

  it "routes using MESH auto-routing demographics in Mex-To" do
    expect(args_for.mex_to).to eq("GPPROVIDER_9999999999_19700102_Jones")
  end

  it "sends direct to the request's recipient mailbox when one is given" do
    direct = plain_delivery_request.with(
      routing: request_class::Routing.new(recipient_mailbox_id: "X26OT112")
    )

    expect(args_for(direct).mex_to).to eq("X26OT112")
  end

  it "uses the document title as the Mex-Subject" do
    expect(args_for.mex_subject).to eq(
      "Consultation report for JONES, Patricia (Ms), NHS Number: 9999999999, " \
      "seen at Test Hospital, RAJ01, Version: 1"
    )
  end

  it "uses the request's composition title and version, so each document type can differ" do
    document = plain_delivery_request.document.with(
      composition_title: "Discharge summary", version: 2
    )
    args = args_for(plain_delivery_request.with(document:))

    xml = described_class.call(args)

    expect(xml).to include('<title value="Discharge summary"/>')
    expect(args.mex_subject).to eq(
      "Discharge summary for JONES, Patricia (Ms), NHS Number: 9999999999, " \
      "seen at Test Hospital, RAJ01, Version: 2"
    )
  end

  it "states restricted confidentiality in the composition" do
    restricted = plain_delivery_request.patient.with(restricted: true)

    xml = described_class.call(args_for(plain_delivery_request.with(patient: restricted)))

    expect(xml).to include('<confidentiality value="R"/>')
  end

  it "refuses a request with no PDF content" do
    document = plain_delivery_request.document.with(pdf_content: nil)

    expect { args_for(plain_delivery_request.with(document:)) }
      .to raise_error(Relay::GPConnect::MissingPdfContentError)
  end

  it "refuses a request with no SNOMED document type" do
    document = plain_delivery_request.document.with(type_snomed_code: nil)

    expect { args_for(plain_delivery_request.with(document:)) }
      .to raise_error(arguments_class::MissingSnomedDocumentTypeError)
  end

  it "builds a urn from a uuid, and nothing from a blank one" do
    expect(args_for.uuid_urn("abc")).to eq("urn:uuid:abc")
    expect(args_for.uuid_urn("")).to be_nil
  end
end
