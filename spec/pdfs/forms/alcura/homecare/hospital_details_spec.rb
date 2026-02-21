# frozen_string_literal: true

RSpec.describe Forms::Alcura::Homecare::HospitalDetails do
  it do # rubocop:disable RSpec/MultipleExpectations
    args = Forms::Homecare::Args.new(
      **default_homecare_args,
      hospital_name: "Hospital1",
      hospital_address: %w(Line1 Line2 Line3),
      hospital_department: "HospDept1",
      hospital_telephone: "1234567",
      consultant: "Mrs Con Sultant"
    )
    doc = test_prawn_doc

    described_class.new(doc, args).build

    text = extract_text_from_prawn_doc(doc)

    expect(text).to include("HOSPITAL DETAILS")
    expect(text).to include("Hospital Name")
    expect(text).to include("Hospital1")
    expect(text).to include("Address")
    expect(text).to include("Line1")
    expect(text).to include("Line2")
    expect(text).to include("Line3")
    expect(text).to include("Department")
    expect(text).to include("HospDept1")
    expect(text).to include("Consultant")
    expect(text).to include("Mrs Con Sultant")
    expect(text).to include("Telephone")
    expect(text).to include("1234567")
  end
end
