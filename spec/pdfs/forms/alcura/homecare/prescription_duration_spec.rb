# frozen_string_literal: true

RSpec.describe Forms::Alcura::Homecare::PrescriptionDuration do
  it do
    args = Forms::Homecare::Args.new(
      **default_homecare_args,
      prescription_durations: ["3 months", "6 months", "12 months"]
    )
    doc = test_prawn_doc

    described_class.new(doc, args).build

    text = extract_text_from_prawn_doc(doc)
    expect(text).to include("Duration of Prescription")
    expect(text).to include("❏ 3 months")
    expect(text).to include("❏ 6 months")
    expect(text).to include("❏ 12 months")
  end

  it "still works if there are no duration frequencies specified" do
    args = Forms::Homecare::Args.new(default_homecare_args)
    doc = test_prawn_doc

    described_class.new(doc, args).build

    text = extract_text_from_prawn_doc(doc)
    expect(text).to include("Duration of Prescription")
  end

  context "when there is a selected prescription_duration" do
    it "indicates that duration has been selected eg for checking a box" do
      args = Forms::Homecare::Args.new(
        **default_homecare_args,
        prescription_durations: ["3 months", "6 months", "12 months"],
        selected_prescription_duration: "6 months"
      )

      doc = test_prawn_doc

      described_class.new(doc, args).build

      text = extract_text_from_prawn_doc(doc)
      expect(text).to include("❏ 3 months")
      expect(text).to include("■ 6 months")
      expect(text).to include("❏ 12 months")
    end
  end
end
