# frozen_string_literal: true

RSpec.describe Forms::Fresenius::Homecare::PrescriberDetailsTable do
  it do
    args = Forms::Homecare::Args.new(
      **default_homecare_args,
      prescriber_name: "Dr XYZ",
      hospital_address: ["h1", nil, "h2", "", "h3"],
      po_number: "PO-123"
    )
    doc = test_prawn_doc

    described_class.new(doc, args).build

    text = extract_text_from_prawn_doc(doc)
    expect(text).to include("Dr XYZ")
    expect(text).to include("h1")
    expect(text).to include("h2")
    expect(text).to include("h3")
    expect(text).to include("PO-123")
  end
end
