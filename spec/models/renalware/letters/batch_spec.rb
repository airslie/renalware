module Renalware
  module Letters
    describe Batch do
      include LettersSpecHelper
      it_behaves_like "an Accountable model"
      it :aggregate_failures do
        is_expected.to have_many :items
        is_expected.to have_many(:letters).through(:items)
      end

      describe "#status" do
        it "defaults to queued" do
          expect(described_class.new).to have_attributes(
            queued?: true,
            processing?: false,
            failure?: false,
            awaiting_printing?: false,
            success?: false
          )
        end
      end

      describe "#letters" do
        it "returns letters added to the batch" do
          user = create(:user)
          letter = create_letter(
            state: :approved,
            to: :patient,
            patient: create(:letter_patient)
          )
          batch = described_class.create!(by: user)
          batch.items.create(letter: letter)

          batch.reload
          expect(batch.letters.count).to eq(1)
          expect(batch.items.count).to eq(1)
        end
      end
    end
  end
end
