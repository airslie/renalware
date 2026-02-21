# frozen_string_literal: true

RSpec.describe Forms::Fresenius::Homecare::PatientDetailsTable do
  subject(:text) { pdf_text(args) }

  let(:no_known_allergies) { false }
  let(:allergies) { [] }
  let(:args) do
    Forms::Homecare::Args.new(
      **default_homecare_args,
      no_known_allergies:,
      allergies:,
      title: "Mr",
      given_name: "Jack",
      family_name: "JONES",
      nhs_number: "1234567890",
      born_on: Date.parse("2001-01-01"),
      telephone: "07000 000001",
      hospital_number: "ABC123",
      postcode: "TW1 1UU",
      address: ["line1", "", nil, "line2", "line3   "]
    )
  end

  def pdf_text(args)
    doc = test_prawn_doc
    described_class.new(doc, args).build
    extract_text_from_prawn_doc(doc)
  end

  describe "patient demograpghics" do
    it :aggregate_failures do
      is_expected.to include(args.title)
      is_expected.to include(args.given_name)
      is_expected.to include(args.family_name)
      is_expected.to include(args.nhs_number)
      is_expected.to include("2001-01-01")
      is_expected.to include(args.telephone)
      is_expected.to include(args.hospital_number)
      is_expected.to include(args.postcode)
      is_expected.to include("line1")
      is_expected.to include("line2")
      is_expected.to include("line3")
    end
  end

  context "when the patient has no known allergies" do
    let(:no_known_allergies) { false }

    it { is_expected.to include("❏") }
  end

  context "when the patient has allergies" do
    let(:allergies) { %w(nuts penicillin) }

    it :aggregate_failures do
      is_expected.to include("nuts")
      is_expected.to include("penicillin")
    end
  end
end
