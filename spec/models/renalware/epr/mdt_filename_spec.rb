describe Renalware::EPR::MdtFilename do
  subject(:filename) { described_class.new(event, :DVH).to_s }

  let(:patient) do
    create(
      :patient,
      local_patient_id_3: "KCHNO",
      family_name: "Jones",
      born_on: Date.new(1990, 1, 1)
    )
  end
  let(:event) { create(:simple_event, patient:) }

  include_context "with DVH as the EPR site"

  it "builds the name from event id, timestamp, padded hospital number, name and dob" do
    timestamp = event.created_at.strftime("%Y%m%d%H%M%S%3N")

    expect(filename).to eq(
      "#{event.id}_MDT_Meeting_Notes_#{timestamp}_00KCHNO_JONES_19900101_CL06.080.pdf"
    )
  end
end
