# frozen_string_literal: true

RSpec.describe Forms::Fresenius::Homecare::PrescriptionsTable do
  it do
    args = Forms::Homecare::Args.new(
      **default_homecare_args,
      selected_prescription_duration: "1 month",
      administration_device: "device1"
    )
    args.medications << Forms::Homecare::Args::Medication.new(
      date: Date.current,
      drug: "Example drug",
      dose: "1 unit",
      route: "Per Oral",
      frequency: "The freq"
    )

    doc = test_prawn_doc

    described_class.new(doc, args).build

    text = extract_text_from_prawn_doc(doc)
    expect(text).to include("Per Oral")
    expect(text).to include("The freq")
    expect(text).to include("Example drug 1 unit")
    expect(text).to include("1 month")
    expect(text).to include("device1")
  end
end
