describe Renalware::Letters::SaveRTFLetterToFileJob do
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
    # removing this test for now as it is failing with a Broken Pipe error on GH 50% of the time
    pending "creates the specific file with the RTF letter content"
    # it "creates the specific file with the RTF letter content" do
    #   file_path = Renalware::Engine.root.join("tmp", "test.rtf")

    #   allow_any_instance_of(Renalware::Letters::LetterPresenter)
    #     .to receive(:to_html).and_return("test")

    #   sleep 1 # attempt to reduce occurrences of Broken Pipe errors
    #   job.perform(letter: letter, file_path: file_path)
    #   sleep 1 # attempt to reduce occurrences of Broken Pipe errors

    #   expect(File.exist?(file_path)).to be(true)
    # end
  end
end
