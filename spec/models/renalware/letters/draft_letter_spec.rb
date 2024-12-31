module Renalware
  module Letters
    describe DraftLetter do
      let(:patient) { create(:patient) }
      let(:instance) { described_class.new }
      let(:topic) { nil }
      let(:letterhead) { create(:letter_letterhead) }
      let(:user) { create(:user) }
      let(:description) { nil }
      let(:params) do
        {
          description: description,
          topic: topic,
          letterhead: letterhead,
          author: user,
          created_by: user
        }
      end

      describe "#call" do
        context "when description is present instead of topic" do
          let(:description) { "test" }

          it "creates a new letter using description" do
            letter = instance.call(patient, params)
            expect(letter).to be_persisted
          end
        end

        context "when a valid topic is passed in" do
          describe "#create_snapshots_for_letter_sections" do
            context "when topic has sections associated with it" do
              let(:topic) { create(:letter_topic, section_identifiers: [:hd_section]) }

              it "creates a snapshot" do
                letter = instance.call(patient, params)
                expect(letter).to be_persisted
                expect(letter.section_snapshots.size).to eq 1
                snapshot = letter.section_snapshots.first

                expect(snapshot.content).to be_present
                expect(snapshot.section_identifier).to eq "hd_section"
              end
            end
          end
        end
      end
    end
  end
end
