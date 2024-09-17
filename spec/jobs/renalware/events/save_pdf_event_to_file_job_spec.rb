# frozen_string_literal: true

describe Renalware::Events::SavePdfEventToFileJob do
  subject(:job) { described_class.new }

  let(:patient) do
    create(
      :letter_patient,
      local_patient_id: "123",
      family_name: "O'Farrel-Boson"
    )
  end

  let(:event) do
    create(
      :simple_event,
      date_time: Time.zone.parse("2017-12-01 09:00:00"),
      patient: patient
    )
  end

  describe "#perform" do
    it "creates the specific file with the pdf event content" do
      file_path = Renalware::Engine.root.join("tmp", "test.pdf")
      create(:hospital_centre, code: Renalware.config.ukrdc_site_code)

      job.perform(event: event, file_path: file_path)

      expect(File.exist?(file_path)).to be(true)
    end
  end
end
