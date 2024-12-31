module Renalware
  module Letters
    describe SectionManager do
      let(:instance) { described_class.new(letter) }

      describe "#sections" do
        let(:letter) {
          Letter.new \
            patient: Patient.new,
            topic: topic,
            letterhead: Letterhead.new,
            clinical: clinical
        }
        let(:topic) { nil }
        let(:clinical) { false }
        let(:sections) { [] }

        context "with clinical letter event" do
          let(:clinical) { true }

          it "returns clinical event sections" do
            expect(instance.sections.size).to eq 4
            expect(instance.sections[0]).to be_a Part::Problems
            expect(instance.sections[1]).to be_a Part::Prescriptions
            expect(instance.sections[2]).to be_a Part::RecentPathologyResults
            expect(instance.sections[3]).to be_a Part::Allergies
          end
        end

        context "with an non-clinical letter event" do
          context "when topic is not present" do
            it "returns no sections" do
              expect(instance.sections.size).to eq 0
            end
          end

          context "when topic is present" do
            let(:topic) { Topic.new(section_identifiers: sections) }

            context "when sections are present" do
              let(:sections) { [:hd_section] }

              it "returns a list of sections sorted by position" do
                expect(instance.sections.size).to eq 1
                expect(instance.sections[0]).to be_a HD::LetterExtensions::HDSection
              end
            end

            context "when sections are not present" do
              it "returns no sections" do
                expect(instance.sections.size).to eq 0
              end
            end
          end
        end
      end

      describe "#edit_sections_for_topic" do
        let(:letter) { Letter.new(topic: topic) }
        let(:topic) { nil }

        context "when topic is present" do
          let(:topic) { Topic.new(section_identifiers: ["hd_section"]) }

          it "returns a list of section classes" do
            edit_topics = instance.edit_sections_for_topic(topic: topic)
            expect(edit_topics.size).to eq 1
            expect(edit_topics.first).to be_a Renalware::HD::LetterExtensions::HDSection
          end
        end

        context "when topic is not present" do
          it "returns an empty array" do
            expect(instance.edit_sections_for_topic).to eq []
          end
        end
      end

      describe described_class::SectionClassFilter do
        describe "#to_h" do
          subject(:filter) { instance.filter }

          let(:sections) { [Part::RecentPathologyResults, Part::Problems] }
          let(:instance) do
            described_class.new(
              sections: sections,
              include_pathology_in_letter_body: include_pathology_in_letter_body
            )
          end

          context "when include_pathology_in_letter_body is true" do
            let(:include_pathology_in_letter_body) { true }

            it { is_expected.to eq([Part::RecentPathologyResults, Part::Problems]) }
          end

          context "when include_pathology_in_letter_body is false" do
            let(:include_pathology_in_letter_body) { false }

            it { is_expected.to eq([Part::Problems]) }
          end
        end
      end

      describe described_class::LCSDiffLeftCallbacks do
        it "creates a diff" do
          data_old = "foo bar"
          data_new = "boo far and more"

          output = []

          callback_obj = described_class.new(output)
          Diff::LCS.traverse_sequences(data_old, data_new, callback_obj)

          expect(output.join.chomp).to include "oo"
          expect(output.join.chomp).to include "ar"
          expect(output.join.chomp).not_to include "more"
        end
      end

      describe described_class::LCSDiffRightCallbacks do
        it "creates a diff" do
          data_old = "foo bar"
          data_new = "boo far and more"

          output = []

          callback_obj = described_class.new(output)
          Diff::LCS.traverse_sequences(data_old, data_new, callback_obj)

          expect(output.join.chomp).to include "oo"
          expect(output.join.chomp).to include "ar"
          expect(output.join.chomp).to include "and more"
        end
      end
    end
  end
end
