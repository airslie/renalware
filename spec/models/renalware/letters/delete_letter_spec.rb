module Renalware
  describe Letters::DeleteLetter do
    include LettersSpecHelper

    subject(:service) do
      described_class.new(letter: letter, by: user).broadcasting_to_configured_subscribers
    end

    let(:patient) { create(:letter_patient) }
    let(:user) { create(:user) }
    let(:unapproved_letter) {
      create_letter(state: :pending_review, to: :patient, patient: patient)
    }
    let(:approved_letter) { unapproved_letter.becomes(Letters::Letter::Approved) }
    let(:completed_letter) { approved_letter.becomes(Letters::Letter::Completed) }

    context "when the letter is not yet approved" do
      let(:letter) { unapproved_letter }

      it "hard deletes" do
        service.call

        expect(Letters::Letter.with_deleted.exists?(id: letter.id)).to be(false)
      end
    end

    context "when the letter is approved" do
      let(:letter) { approved_letter }

      it "soft deletes by setting deleted_at and deleted_by" do
        freeze_time do
          service.call

          deleted_letter = Letters::Letter.with_deleted.find(letter.id)
          expect(deleted_letter).to have_attributes(
            deleted_at: Time.zone.now,
            deleted_by_id: user.id
          )
        end
      end

      it "touches the patient" do
        patient
        letter
        expect {
          service.call
        }.to change(letter.patient, :updated_at)
      end

      describe "broadcasting" do
        it "broadcasts before_and after_letter_deleted events" do
          expect {
            service.call
          }.to broadcast(:before_letter_deleted, letter.becomes(Letters::Letter))
            .and broadcast(:after_letter_deleted, letter.becomes(Letters::Letter))
        end
      end

      context "when the letter is completed" do
        let(:letter) { completed_letter }

        it "soft deletes by setting deleted_at and deleted_by" do
          freeze_time do
            service.call
            deleted_letter = Letters::Letter.with_deleted.find(letter.id)
            expect(deleted_letter).to have_attributes(
              deleted_at: Time.zone.now,
              deleted_by_id: user.id
            )
          end
        end
      end
    end
  end
end
