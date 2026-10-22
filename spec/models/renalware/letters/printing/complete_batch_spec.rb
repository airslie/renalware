describe Renalware::Letters::Printing::CompleteBatch do
  include LettersSpecHelper

  include_context "with DVH as the EPR site"

  let(:user) { create(:user) }

  before do
    ActiveJob::Base.queue_adapter = :test
    allow(Renalware.config).to receive(:broadcast_subscription_map).and_return(
      "Renalware::Letters::CompleteLetter" => ["Renalware::EPR::LetterListener"]
    )
  end

  def create_batch
    batch = Renalware::Letters::Batch.create!(by: user)
    letter1 = create_approved_letter_to_patient_with_cc_to_gp_and_one_contact(page_count: 1)
    letter2 = create_approved_letter_to_patient_with_cc_to_gp_and_one_contact(page_count: 1)
    batch.items.create(letter: letter1)
    batch.items.create(letter: letter2)
    batch
  end

  it do
    batch = create_batch

    described_class.new(user:, batch:).call

    batch.reload
    expect(batch.status).to eq("success")
    letters = batch.letters
    expect(letters.count).to eq(2)
    expect(letters.reject(&:completed?)).to be_empty
  end

  it "exports batch letters for the EPR site, leaving other patients unexported" do
    batch = create_batch
    letter = batch.letters.first
    letter.patient.update_columns(local_patient_id_3: "345")

    expect { described_class.new(user:, batch:).call }
      .to have_enqueued_job(Renalware::EPR::SaveLetterJob).exactly(2).times
    expect(batch.letters.reload).to all(be_completed)
  end

  it "does not export when no EPR subscriber is configured" do
    allow(Renalware.config).to receive(:broadcast_subscription_map).and_return({})
    batch = create_batch
    batch.letters.first.patient.update_columns(local_patient_id_3: "345")

    expect { described_class.new(user:, batch:).call }
      .not_to have_enqueued_job(Renalware::EPR::SaveLetterJob)
    expect(batch.letters.reload).to all(be_completed)
  end
end
