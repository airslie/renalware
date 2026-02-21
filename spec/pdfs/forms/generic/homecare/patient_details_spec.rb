# frozen_string_literal: true

RSpec.describe Forms::Generic::Homecare::PatientDetails do
  it do
    hash = default_test_arg_values.update(
      given_name: "John",
      family_name: "SMITH",
      title: "Mr",
      modality: "HD",
      born_on: "2001-01-01",
      nhs_number: "0123456789",
      hospital_number: "X123",
      address: %w(aa bb cc),
      postcode: "POSTCODE"
    )
    args = Forms::Homecare::Args.new(hash)
    doc = test_prawn_doc

    described_class.new(doc, args).build

    text = extract_text_from_prawn_doc(doc)

    expect(text).to include("SMITH, John (Mr)")
    expect(text).to include("HD")
    expect(text).to include("2001-01-01")
    expect(text).to include("0123456789")
    expect(text).to include("X123")
    expect(text).to include("aa")
    expect(text).to include("bb")
    expect(text).to include("cc")
    expect(text).to include("POSTCODE")
  end
end
