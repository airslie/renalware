describe Renalware::EPR::LetterFilename do
  subject(:filename) { described_class.new(letter, :DVH).to_s }

  let(:patient) do
    create(
      :letter_patient,
      local_patient_id_3: "345",
      family_name: "O'Farrel-Boson",
      born_on: Date.new(2013, 1, 1)
    )
  end
  let(:letter) do
    instance_double(
      Renalware::Letters::Letter,
      id: 999,
      patient:,
      approved_at: Time.zone.parse("2017-12-01 12:34:56.789")
    )
  end

  include_context "with DVH as the EPR site"

  it "builds the name from letter id, timestamp, padded hospital number, name and dob" do
    expect(filename).to eq(
      "999_Renal_Outpatient_Letter_20171201123456789_0000345_OFARRELBOS_20130101_CO03.011.pdf"
    )
  end

  it "uses the configured letter document type" do
    allow(Renalware.config).to receive(:epr_letter_document_type).and_return("XX01")

    expect(filename).to end_with("_XX01.pdf")
  end
end
