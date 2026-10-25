describe Renalware::EPR::LetterListener do
  include LettersSpecHelper

  include_context "with DVH as the EPR site"

  let(:patient) { create(:letter_patient, local_patient_id_3: "345") }
  let(:letter) { create_letter(state: :approved, to: :patient, patient:) }
  let(:filename) { "a_filename.pdf" }
  let(:base_letter) { letter.becomes(Renalware::Letters::Letter) }

  before do
    allow(Renalware.config).to receive(:epr_letters_folder).and_return("/var/epr")
    ActiveJob::Base.queue_adapter = :test
    allow(Renalware::EPR::LetterFilename).to receive(:new)
      .and_return(instance_double(Renalware::EPR::LetterFilename, to_s: filename))
  end

  it "saves the letter to the site's tmp folder" do
    expect { described_class.new.letter_completed(letter) }
      .to have_enqueued_job(Renalware::EPR::SaveLetterJob)
      .on_queue("pdf_generation")
      .with(letter: base_letter, file_path: "/var/epr/tmp/dvh/#{filename}")
  end

  it "saves the letter to the site's archive folder" do
    expect { described_class.new.letter_completed(letter) }
      .to have_enqueued_job(Renalware::EPR::SaveLetterJob)
      .with(letter: base_letter, file_path: "/var/epr/archive/dvh/#{filename}")
  end

  it "does nothing for a patient who is not at the site" do
    patient.update_columns(local_patient_id_3: nil)

    expect { described_class.new.letter_completed(letter.reload) }
      .not_to have_enqueued_job(Renalware::EPR::SaveLetterJob)
  end
end
