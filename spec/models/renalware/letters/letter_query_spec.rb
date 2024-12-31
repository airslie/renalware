module Renalware
  module Letters
    describe LetterQuery do
      include LettersSpecHelper
      subject(:query) { described_class.new }

      let(:primary_care_physician) { create(:letter_primary_care_physician) }
      let(:patient) { create(:letter_patient, primary_care_physician: primary_care_physician) }

      describe "#call" do
        before do
          create_letter_in_state(:draft)
          create_letter_in_state(:pending_review)
          create_letter_in_state(:approved)
        end

        context "when there are no filters" do
          it "returns all letters" do
            expect(query.call.count).to eq(3)

            # Check effective date; Default is desc
            expect(query.call.map(&:state)).to eq %w(approved pending_review draft)

            query = described_class.new(q: { s: "effective_date asc" })
            expect(query.call.map(&:state)).to eq %w(draft pending_review approved)

            query = described_class.new(q: { s: "effective_date desc" })
            expect(query.call.map(&:state)).to eq %w(approved pending_review draft)
          end
        end
      end

      private

      def create_letter_in_state(state)
        create_letter(state: state, to: :patient, patient: patient, created_at: DateTime.now)
      end
    end
  end
end
