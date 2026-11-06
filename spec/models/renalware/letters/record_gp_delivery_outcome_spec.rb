module Renalware::Letters
  describe RecordGPDeliveryOutcome do
    include LettersSpecHelper
    include MeshSpecHelper

    let(:user) { create(:user) }
    let(:patient) { create_mesh_patient(user:) }
    let(:letter) do
      create_mesh_letter_to_gp(patient, user).tap { |l| l.update!(gp_send_status: :pending) }
    end

    def reloaded(letter) = Letter.find(letter.id)

    it "on success, flags the GP copy as sent" do
      described_class.call(letter_id: letter.id, outcome: :success)

      expect(reloaded(letter).gp_send_status).to eq("success")
    end

    it "on success, completes the letter if the GP was the only recipient" do
      expect(letter.recipients.map(&:person_role)).to eq([:primary_care_physician])

      expect {
        described_class.call(letter_id: letter.id, outcome: :success)
      }.to broadcast(:letter_completed)

      expect(Letter::Completed.find(letter.id)).to have_attributes(completed_by: user)
    end

    it "on success, does not complete the letter if other recipients still need a printed copy" do
      letter = create_mesh_letter_to_gp(patient, user, to: :patient)
      letter.recipients.create!(person_role: "primary_care_physician", role: "cc")
      letter.update!(gp_send_status: :pending)

      expect {
        described_class.call(letter_id: letter.id, outcome: :success)
      }.not_to broadcast(:letter_completed)

      expect(reloaded(letter)).to have_attributes(gp_send_status: "success", completed_at: nil)
    end

    it "on success, uses a letter it is given rather than loading it again" do
      loaded_letter = Letter.find(letter.id)
      queries = []
      callback = lambda do |*, payload|
        queries << payload[:sql] if payload[:sql].match?(/FROM.*letter_letters/)
      end

      ActiveSupport::Notifications.subscribed(callback, "sql.active_record") do
        described_class.call(letter: loaded_letter, outcome: :success)
      end

      expect(queries.grep(/\ASELECT/)).to be_empty
      expect(reloaded(letter).gp_send_status).to eq("success")
    end

    it "on failure, flags the GP copy as failed so it appears in the list to print" do
      described_class.call(letter_id: letter.id, outcome: :failure)

      expect(reloaded(letter).gp_send_status).to eq("failure")
    end

    it "on failure, does not complete the letter" do
      expect {
        described_class.call(letter_id: letter.id, outcome: :failure)
      }.not_to broadcast(:letter_completed)
    end

    it "rejects an unknown outcome" do
      expect {
        described_class.call(letter_id: letter.id, outcome: :banana)
      }.to raise_error(ArgumentError, /outcome/)
    end
  end
end
