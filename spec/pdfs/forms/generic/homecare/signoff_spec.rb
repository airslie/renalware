# frozen_string_literal: true

RSpec.describe Forms::Generic::Homecare::Signoff do
  it do
    args = Forms::Homecare::Args.new(
      **default_test_arg_values.update(consultant: "Dr Pepper")
    )
    doc = test_prawn_doc

    described_class.new(doc, args).build

    text = extract_text_from_prawn_doc(doc)
    expect(text).to include("Dr Pepper")
  end
end
