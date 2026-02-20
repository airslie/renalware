module Renalware
  module Letters
    describe LetterPresenter do
      subject(:presenter) { described_class.new(letter) }

      let(:patient) { instance_double(Patient, local_patient_id: "A123", family_name: "Jones") }
      let(:letter) { instance_double(Letter, patient:, id: 111, state: :draft) }

      describe "#pdf_filename" do
        it "returns a formatted filename inclusing the letter state" do
          expect(presenter.pdf_filename).to eq("JONES-A123-111-DRAFT.pdf")
        end
      end

      describe "#pdf_stateless_filename" do
        it "returns a formatted filename exluding the letter state" do
          expect(presenter.pdf_stateless_filename).to eq("JONES-A123-111.pdf")
        end
      end

      describe "#parts" do
        let(:letter) {
          Letter.new \
            patient: Patient.new,
            topic:,
            letterhead: Letterhead.new,
            clinical:
        }
        let(:topic) { nil }
        let(:clinical) { false }

        context "with clinical letter event" do
          let(:clinical) { true }

          it "returns clinical event sections" do
            expect(presenter.parts.size).to eq 4
            expect(presenter.parts[0]).to be_a Part::Problems
            expect(presenter.parts[1]).to be_a Part::Prescriptions
            expect(presenter.parts[2]).to be_a Part::RecentPathologyResults
            expect(presenter.parts[3]).to be_a Part::Allergies
          end
        end

        context "with a non-clinical letter event" do
          context "when topic is not present" do
            it "returns no parts" do
              expect(presenter.parts.size).to eq 0
            end
          end
        end
      end
    end
  end
end
