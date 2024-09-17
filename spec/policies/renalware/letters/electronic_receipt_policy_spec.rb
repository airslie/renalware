# frozen_string_literal: true

module Renalware::Letters
  describe ElectronicReceiptPolicy, type: :policy do
    subject(:policy) { described_class }

    permissions :mark_as_read? do
      it "does not grant access if already read" do
        expect(policy).not_to permit(
          build_stubbed(:user),
          build_stubbed(
            :letter_electronic_receipt,
            letter: build_stubbed(:approved_letter),
            read_at: Time.zone.now
          )
        )
      end

      it "does not grant access if unread but not letter is draft" do
        expect(policy).not_to permit(
          build_stubbed(:user),
          build_stubbed(
            :letter_electronic_receipt,
            letter: build_stubbed(:draft_letter),
            read_at: nil
          )
        )
      end

      it "does not grant access if unread but not letter is pending review" do
        expect(policy).not_to permit(
          build_stubbed(:user),
          build_stubbed(
            :letter_electronic_receipt,
            letter: build_stubbed(:pending_review_letter),
            read_at: nil
          )
        )
      end

      it "grants access if unread and letter is approved" do
        expect(policy).to permit(
          build_stubbed(:user),
          build_stubbed(
            :letter_electronic_receipt,
            letter: build_stubbed(:approved_letter),
            read_at: nil
          )
        )
      end

      it "grants access if unread and letter is completed" do
        expect(policy).to permit(
          build_stubbed(:user),
          build_stubbed(
            :letter_electronic_receipt,
            letter: build_stubbed(:completed_letter),
            read_at: nil
          )
        )
      end
    end
  end
end
