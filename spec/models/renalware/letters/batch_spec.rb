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
            patient: create(:letter_patient, :minimal)
          )
          batch = described_class.create!(by: user)
          batch.items.create(letter: letter)

          batch.reload
          expect(batch.letters.count).to eq(1)
          expect(batch.items.count).to eq(1)
        end
      end

      describe "#percent_complete" do
        context "when batch_items_count is nil" do
          it "returns 0 without raising an error" do
            batch = described_class.new
            batch.batch_items_count = nil

            expect { batch.percent_complete }.not_to raise_error
            expect(batch.percent_complete).to eq(0)
          end
        end

        context "when batch_items_count is zero" do
          it "returns 0 without raising an error" do
            batch = described_class.new
            batch.batch_items_count = 0

            expect { batch.percent_complete }.not_to raise_error
            expect(batch.percent_complete).to eq(0)
          end
        end

        context "when items are present" do
          it "calculates percentage correctly" do
            user = create(:user)
            batch = described_class.create!(by: user)
            letter1 = create_letter(
              state: :approved,
              to: :patient,
              patient: create(:letter_patient, :minimal)
            )
            letter2 = create_letter(
              state: :approved,
              to: :patient,
              patient: create(:letter_patient, :minimal)
            )
            batch.items.create(letter: letter1, status: :compiled)
            batch.items.create(letter: letter2, status: :queued)

            batch.reload
            expect(batch.percent_complete).to eq(50)
          end
        end
      end
    end
  end
end
