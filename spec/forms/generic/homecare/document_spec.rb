# frozen_string_literal: true

RSpec.describe Forms::Generic::Homecare::Document do
  describe "#build" do
    context "when allergies are enabled" do
      before do
        allow(Renalware.config).to receive(:enable_allergies).and_return(true)
      end

      it "includes the Allergies section" do
        args = Forms::Homecare::Args.new(
          **default_test_arg_values, allergies: ["nuts"],
                                     no_known_allergies: false
        )

        pdf = described_class.build(args)
        text = extract_text_from_prawn_doc(pdf.document)

        expect(text).to include("Known Allergies")
        expect(text).to include("nuts")
      end
    end

    context "when allergies are disabled" do
      before do
        allow(Renalware.config).to receive(:enable_allergies).and_return(false)
      end

      it "does not include the Allergies section" do
        args = Forms::Homecare::Args.new(
          **default_test_arg_values, allergies: nil,
                                     no_known_allergies: false
        )

        pdf = described_class.build(args)
        text = extract_text_from_prawn_doc(pdf.document)

        expect(text).not_to include("Known Allergies")
        expect(text).not_to include("No Known Allergies")
      end
    end
  end
end
