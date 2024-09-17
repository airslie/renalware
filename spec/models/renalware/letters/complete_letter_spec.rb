# frozen_string_literal: true

module Renalware
  describe Letters::CompleteLetter do
    include LettersSpecHelper
    let(:patient) { create(:letter_patient) }
    let(:user) { create(:user) }

    it "broadcasts a letter_approved event when the letter is approved successfully" do
      letter = create_letter(state: :approved, to: :patient, patient: patient)
      completed_letter = letter.becomes(Letters::Letter::Completed)

      expect {
        described_class.build(letter).call(by: user)
      }.to broadcast(:letter_completed, completed_letter)
    end

    it "updates when and by who the letter was approved" do
      letter = create_letter(state: :approved, to: :patient, patient: patient)
      completed_letter = letter.becomes(Letters::Letter::Completed)

      time = Time.zone.now
      travel_to(time) do
        described_class.build(letter).call(by: user)
      end

      completed_letter.reload
      expect(completed_letter.completed_by).to eq(user)
      expect(completed_letter.completed_at.to_s).to eq(time.to_s)
    end
  end
end
