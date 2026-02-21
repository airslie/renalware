# frozen_string_literal: true

RSpec.describe Forms::Generic::Homecare::Allergies do
  context "when the patient has iit recoreded that they have no known allergies" do
    it do
      hash = default_test_arg_values.update(no_known_allergies: true)
      args = Forms::Homecare::Args.new(hash)
      doc = test_prawn_doc

      described_class.new(doc, args).build

      text = extract_text_from_prawn_doc(doc)
      expect(text).to include("No Known Allergies")
    end
  end

  it do
    hash = default_test_arg_values.update(
      no_known_allergies: false,
      allergies: %w(nuts penicillin)
    )
    args = Forms::Homecare::Args.new(hash)
    doc = test_prawn_doc

    described_class.new(doc, args).build

    text = extract_text_from_prawn_doc(doc)

    expect(text).not_to include("No Known Allergies")
    expect(text).to include("Known Allergies")
    expect(text).to include("nuts")
    expect(text).to include("penicillin")
  end
end
