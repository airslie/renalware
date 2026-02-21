# frozen_string_literal: true

RSpec.describe Forms::Alcura::Homecare::OrderDetails do
  it do
    args = Forms::Homecare::Args.new(default_homecare_args)
    doc = test_prawn_doc

    described_class.new(doc, args).build

    text = extract_text_from_prawn_doc(doc)

    expect(text).to include("ORDER DETAILS")
    expect(text).to include("New Patient ❏")
    expect(text).to include("Renewal ❏")
    expect(text).to include("Drug/Dose change ❏")
    expect(text).to include("Self funded")
    expect(text).to include("Manufacturer funded")
    expect(text).to include("PO")
    expect(text).to include("Blueteq")
  end
end
