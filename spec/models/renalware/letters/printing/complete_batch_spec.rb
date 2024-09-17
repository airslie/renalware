# frozen_string_literal: true

module Renalware
  module Letters
    describe Printing::CompleteBatch do
      include LettersSpecHelper

      let(:user) { create(:user) }

      def create_batch
        batch = Letters::Batch.create!(by: user)
        letter1 = create_approved_letter_to_patient_with_cc_to_gp_and_one_contact(page_count: 1)
        letter2 = create_approved_letter_to_patient_with_cc_to_gp_and_one_contact(page_count: 1)
        batch.items.create(letter: letter1)
        batch.items.create(letter: letter2)
        batch
      end

      it do
        batch = create_batch

        described_class.new(user: user, batch: batch).call

        batch.reload
        expect(batch.status).to eq("success")
        letters = batch.letters
        expect(letters.count).to eq(2)
        expect(letters.reject(&:completed?)).to be_empty
      end
    end
  end
end
