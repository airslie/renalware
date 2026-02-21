# frozen_string_literal: true

RSpec.describe Forms::Alcura::Homecare::Medications do
  it do # rubocop:disable RSpec/MultipleExpectations
    args = Forms::Homecare::Args.new(**default_homecare_args)
    args.medications << Forms::Homecare::Args::Medication.new(
      date: "2020-01-01",
      drug: "Drug1",
      dose: "Dose1",
      route: "Route1",
      frequency: "Freq1"
    )
    args.medications << Forms::Homecare::Args::Medication.new(
      date: "2020-02-02",
      drug: "Drug2",
      dose: "Dose2",
      route: "Route2",
      frequency: "Freq2"
    )
    doc = test_prawn_doc

    described_class.new(doc, args).build

    text = extract_text_from_prawn_doc(doc)

    expect(text).to include("MEDICATION")
    expect(text).to include("Strength")
    expect(text).to include("Form")
    expect(text).to include("Directions")
    expect(text).to include("Route")
    expect(text).to include("Total")

    expect(text).to include("Drug1")
    expect(text).to include("Dose1")
    expect(text).to include("Route1")
    expect(text).to include("Freq1")
    expect(text).to include("Drug2")
  end
end
