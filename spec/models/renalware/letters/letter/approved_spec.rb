module Renalware::Letters
  describe Letter::Approved do
    include LettersSpecHelper

    subject(:letter) { build(:approved_letter, patient: patient) }

    let(:user) { build(:user) }
    let(:primary_care_physician) { build(:letter_primary_care_physician) }
    let(:patient) { build(:letter_patient, primary_care_physician: primary_care_physician) }

    describe "#complete" do
      it "completed the letter" do
        completed_letter = letter.complete(by: user)
        expect(completed_letter).to be_completed
      end
    end
  end
end
