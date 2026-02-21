# frozen_string_literal: true

RSpec.describe Forms::Fresenius::Homecare::ModalityTable do
  it do
    args = Forms::Homecare::Args.new(
      modality: "HD",
      **default_homecare_args
    )
    doc = test_prawn_doc

    described_class.new(doc, args).build

    text = extract_text_from_prawn_doc(doc)

    expect(text).to include("HD")
  end
end
