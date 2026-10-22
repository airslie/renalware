module Renalware
  module Letters::Delivery::Email
    describe PracticeListener do
      describe "#letter_approved" do
        it "emails the approved letter to the patient's practice" do
          letter = instance_double(Letters::Letter)
          allow(EmailLetterToPractice).to receive(:call)

          described_class.new.letter_approved(letter)

          expect(EmailLetterToPractice).to have_received(:call).with(letter)
        end
      end
    end
  end
end
