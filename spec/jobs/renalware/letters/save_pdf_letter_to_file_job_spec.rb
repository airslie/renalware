describe Renalware::Letters::SavePdfLetterToFileJob do
  include LettersSpecHelper
  subject(:job) { described_class.new }

  let(:patient) do
    create(
      :letter_patient,
      local_patient_id: "123",
      family_name: "O'Farrel-Boson"
    )
  end

  let(:letter) do
    create_letter(
      state: :approved,
      to: :patient,
      patient: patient
    )
  end

  describe "#perform" do
    it "creates the specific file with the pdf letter content" do
      file_path = Renalware::Engine.root.join("tmp", "test.pdf")

      allow_any_instance_of(Renalware::Letters::LetterPresenter)
        .to receive(:to_html).and_return("test")

      job.perform(letter: letter, file_path: file_path)

      expect(File.exist?(file_path)).to be(true)
    end
  end
end
