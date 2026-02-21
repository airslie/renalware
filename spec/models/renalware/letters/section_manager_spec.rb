module Renalware
  module Letters
    describe SectionManager do
      let(:instance) { described_class.new(letter) }

      describe "#sections" do
        let(:letter) {
          Letter.new(
            patient: Patient.new,
            topic:,
            letterhead: Letterhead.new,
            clinical:
          )
        }
        let(:topic) { nil }
        let(:clinical) { false }
        let(:sections) { [] }

        before do
          # by default expect allergies part to be included on the letter
          allow(Renalware.config).to receive_messages(enable_allergies: true)
        end

        context "with clinical letter event" do
          let(:clinical) { true }

          it "returns clinical event sections" do
            expect(instance.parts.size).to eq 4
            expect(instance.parts[0]).to be_a Part::Problems
            expect(instance.parts[1]).to be_a Part::Prescriptions
            expect(instance.parts[2]).to be_a Part::RecentPathologyResults
            expect(instance.parts[3]).to be_a Part::Allergies
          end
        end

        context "with an non-clinical letter event" do
          context "when topic is not present" do
            it "returns no sections" do
              expect(instance.parts.size).to eq 0
            end
          end
        end
      end

      describe described_class::SectionClassFilter do
        describe "#to_h" do
          subject(:filter) { instance.filter }

          let(:parts) { [Part::RecentPathologyResults, Part::Problems, Part::Allergies] }
          let(:instance) do
            described_class.new(
              parts:,
              include_pathology_in_letter_body:
            )
          end

          context "when include_pathology_in_letter_body is true" do
            let(:include_pathology_in_letter_body) { true }

            it { is_expected.to eq parts }
          end

          context "when include_pathology_in_letter_body is false" do
            let(:include_pathology_in_letter_body) { false }

            it { is_expected.to eq([Part::Problems, Part::Allergies]) }
          end

          context "when allergies parts is configured to be excluded from the letter" do
            # This spec tests the identifier on each part, rather then the class, for interest
            subject(:filter) { instance.filter.map(&:identifier) }

            let(:include_pathology_in_letter_body) { true }

            before do
              allow(Renalware.config).to receive_messages(enable_allergies: false)
            end

            it { is_expected.to eq %i(recent_pathology_results problems) }
          end
        end
      end
    end
  end
end
