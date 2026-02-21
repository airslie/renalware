# frozen_string_literal: true

RSpec.describe Forms::Alcura::Homecare::DeliveryFrequency do
  it do
    args = Forms::Homecare::Args.new(**default_homecare_args)
    doc = test_prawn_doc

    described_class.new(doc, args).build

    text = extract_text_from_prawn_doc(doc)

    expect(text).to include("Delivery Frequency")
    expect(text).to include("Once")
    expect(text).to include("4 weeks")
    expect(text).to include("8 weeks")
    expect(text).to include("12 weeks")
    expect(text).to include("Other")
  end

  it "still works if there are no delivery frequencies specified" do
    args = Forms::Homecare::Args.new(**default_homecare_args)
    doc = test_prawn_doc

    described_class.new(doc, args).build

    text = extract_text_from_prawn_doc(doc)

    expect(text).to include("Delivery Frequency")
  end
end
