# frozen_string_literal: true

module Renalware
  module Letters
    RSpec.describe ReviseLetter do
      include LettersSpecHelper
      subject(:service) { described_class.new }

      let(:user) { create(:user) }
      let(:patient) { create(:letter_patient) }
      let(:topic) { nil }

      let(:letter) {
        create(:draft_letter,
               description: "TestDescription",
               patient: patient,
               topic: topic,
               main_recipient: build(:letter_recipient, :main),
               by: user)
      }

      describe ".call" do
        context "when all is good" do
          it "updates the letter" do
            expect_subject_to_broadcast(:revise_letter_successful, letter)

            service.call(patient, letter.id, description: "Foo", by: user)
              .on(:revise_letter_successful) do |letter|
                # Those don't work
                expect(letter.description).to eq("Foo")
                expect(letter).to be_persisted
              end
          end

          context "when topic hasn't changed" do
            let(:topic) { create(:letter_topic, section_identifiers: [:hd_section]) }

            it "doesn't generate snapshots" do
              expect(letter.section_snapshots.count).to eq 0

              service.call(patient, letter.id, by: user, topic_id: topic.id)

              expect(letter.section_snapshots.count).to eq 0
            end
          end

          context "when topic has changed" do
            let(:topic) { create(:letter_topic, section_identifiers: [:hd_section]) }
            let(:new_topic) { create(:letter_topic, section_identifiers: [:hd_section]) }

            context "when also new topic has sections associated with it" do
              it "generates snapshots for those letter sections" do
                expect(letter.section_snapshots.count).to eq 0

                service.call(patient, letter.id, by: user, topic_id: new_topic.id)

                expect(letter.section_snapshots.count).to eq 1

                snapshot = letter.section_snapshots.first
                expect(snapshot.section_identifier).to eq "hd_section"
                expect(snapshot.content).to include "<dl></dl>"
              end
            end

            context "when an existing snapshot was already there for this section" do
              it "keeps it as it is" do
                create(
                  :section_snapshot,
                  letter: letter,
                  content: "test",
                  section_identifier: "hd_section"
                )

                expect(letter.section_snapshots.first.content).to eq "test"

                service.call(patient, letter.id, by: user, topic_id: new_topic.id)

                expect(letter.section_snapshots.count).to eq 1

                snapshot = letter.section_snapshots.first
                expect(snapshot.section_identifier).to eq "hd_section"
                expect(snapshot.content).to include "test"
              end
            end
          end

          context 'when "update_sections" is passed as parameter' do
            context "when section snapshots have been previously created" do
              let!(:section_snapshot) {
                create(:section_snapshot, letter: letter, section_identifier: "hd_section",
                                          content: "old content")
              }

              context "when also a true value has been passed in" do
                it "updates the snapshot content" do
                  service.call(patient, letter.id, by: user, update_sections: { hd_section: "1" })
                  expect(section_snapshot.reload.content).to include "<dl></dl>"
                end

                context "when also a false value has been passed in" do
                  it "doesn't update" do
                    service.call(patient, letter.id, by: user, update_sections: { hd_section: "0" })
                    expect(section_snapshot.reload.content).to eq "old content"
                  end
                end
              end
            end

            context "when section snapshots have not existed for this letter" do
              context "when also a true value has been passed in" do
                it "creates the snapshot content" do
                  service.call(patient, letter.id, by: user, update_sections: { hd_section: "1" })

                  expect(letter.section_snapshots.count).to eq 1

                  snapshot = letter.section_snapshots.first
                  expect(snapshot.section_identifier).to eq "hd_section"
                  expect(snapshot.content).to include "<dl></dl>"
                end
              end
            end
          end
        end

        context "when letter cannot be persisted" do
          it "broadcasts :revise_letter_failed" do
            expect_subject_to_broadcast(:revise_letter_failed, kind_of(Letters::Letter))

            service.call(patient, letter.id, description: nil, by: nil)
              .on(:revise_letter_failed) do |letter|
                # Those don't work
                expect(letter.description).to eq("TestDescription")
                expect(letter.errors).to eq("TestDescription")
              end
          end
        end
      end

      # We use a double rather than a spy here as we want to the double to send the original msg.
      # rubocop:disable RSpec/MessageSpies
      def expect_subject_to_broadcast(*)
        expect(subject).to receive(:broadcast).with(*).and_call_original
      end
      # rubocop:enable RSpec/MessageSpies
    end
  end
end
