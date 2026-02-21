# frozen_string_literal: true

RSpec.describe Forms::Generic::Homecare::PrescriptionDurations do
  def extract_pdf_text(args)
    doc = test_prawn_doc
    described_class.new(doc, args).build
    extract_text_from_prawn_doc(doc)
  end

  it do
    hash = default_test_arg_values.update(
      prescription_durations: ["3 months", "6 months", "12 months"]
    )
    args = Forms::Homecare::Args.new(hash)

    text = extract_pdf_text(args)

    expect(text).to include("Repeat prescription for")
    expect(text).to match(/❏ +3 months/)
    expect(text).to match(/❏ +6 months/)
    expect(text).to match(/❏ +12 months/)
  end

  it "works where there are no prescription_durations supplied" do
    args = Forms::Homecare::Args.new(default_test_arg_values)

    text = extract_pdf_text(args)

    expect(text).to include("Repeat prescription for")
  end

  context "when there is a selected prescription_duration" do
    it "indicates that duration has been selected eg for checking a box" do
      args = Forms::Homecare::Args.new(
        default_test_arg_values.update(
          prescription_durations: ["3 months", "6 months", "12 months"],
          selected_prescription_duration: "6 months"
        )
      )

      text = extract_pdf_text(args)

      expect(text).to match(/❏ +3 months/)
      expect(text).to match(/■ +6 months/)
      expect(text).to match(/❏ +12 months/)
    end
  end
end
