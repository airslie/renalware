RSpec.describe Relay::GPConnect::DeliveryRequest do
  # rubocop:disable-next Metrics/MethodLength
  def build_request(pdf_content: "%PDF", type_code: "371531000", type_title: "Report")
    described_class.new(
      patient: described_class::Patient.new(
        uuid: "p", nhs_number: "9999999999", born_on: Date.new(1970, 1, 2), given_name: "A",
        family_name: "B", title: "Ms", display_name: "B, A (Ms)", sex_code: "F", telephone: nil,
        email: nil, restricted: false, address: nil, local_patient_ids: []
      ),
      author: described_class::Author.new(
        uuid: "a", given_name: "C", family_name: "D", professional_position: "Consultant"
      ),
      document: described_class::Document.new(
        uuid: "d", binary_uuid: "b", approved_at: Time.utc(2022, 1, 1), pdf_content:,
        type_snomed_code: type_code, type_snomed_title: type_title,
        composition_title: "Consultation report", version: 1
      ),
      sender: described_class::Sender.new(
        uuid: "s", itk_uuid: "i", ods_code: "RAJ01", name: "Hospital", phone: nil, email: nil,
        mailbox_id: "MB1", care_setting_snomed_code: "788003006",
        care_setting_description: "Nephrology service"
      ),
      routing: described_class::Routing.new(recipient_mailbox_id: nil)
    )
  end

  it "is immutable" do
    expect(build_request).to be_frozen
    expect(build_request.patient).to be_frozen
  end

  it "can be copied with a changed part" do
    changed = build_request.with(routing: described_class::Routing.new(recipient_mailbox_id: "X"))

    expect(changed.routing.recipient_mailbox_id).to eq("X")
    expect(build_request.routing.recipient_mailbox_id).to be_nil
  end

  it "knows when the PDF is missing" do
    expect(build_request).not_to be_pdf_missing
    expect(build_request(pdf_content: nil)).to be_pdf_missing
    expect(build_request(pdf_content: "")).to be_pdf_missing
  end

  it "knows when the document type is missing" do
    expect(build_request).not_to be_document_type_missing
    expect(build_request(type_code: nil)).to be_document_type_missing
    expect(build_request(type_title: "")).to be_document_type_missing
  end
end
