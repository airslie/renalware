# frozen_string_literal: true

RSpec.describe Forms::Alcura::Homecare::PatientDetails do
  it do # rubocop:disable RSpec/MultipleExpectations
    args = Forms::Homecare::Args.new(
      **default_homecare_args,
      title: "Mr",
      given_name: "Roger",
      family_name: "Rabbit",
      born_on: Date.parse("2001-01-01"),
      hospital_number: "abcde",
      nhs_number: "nhsnumber123",
      allergies: %w(nuts penicillin),
      telephone: "12345"
    )
    doc = test_prawn_doc

    described_class.new(doc, args).build

    text = extract_text_from_prawn_doc(doc)

    expect(text).to include("PATIENT DETAILS")
    expect(text).to include("First Name")
    expect(text).to include("Roger")
    expect(text).to include("Surname")
    expect(text).to include("Rabbit")
    expect(text).to include("Telephone")
    expect(text).to include("12345")
    expect(text).to include("Date of Birth")
    expect(text).to include("2001-01-01")
    expect(text).to include("Hospital Number")
    expect(text).to include("abcde")
    expect(text).to include("NHS Number")
    expect(text).to include("nhsnumber123")
    expect(text).to include("nuts")
    expect(text).to include("penicillin")
  end

  context "when no_known_allergies is excplicitly set" do
    it do
      args = Forms::Homecare::Args.new(
        **default_homecare_args,
        no_known_allergies: true
      )

      doc = test_prawn_doc
      described_class.new(doc, args).build

      text = extract_text_from_prawn_doc(doc)
      expect(text).to include("No Known Allergies")
    end
  end
end
