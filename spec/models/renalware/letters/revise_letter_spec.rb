require "rails_helper"

module Renalware
  module Letters
    RSpec.describe ReviseLetter do
      include LettersSpecHelper
      let(:user) { create(:user) }
      let(:patient) { create(:letter_patient) }
      let(:topic) { nil }

      let(:letter) {
        create(:draft_letter,
               description: "TestDescription",
               patient: patient,
               topic: topic,
               main_recipient: build(:letter_recipient, :main),
               # How does `by` work?
               by: user)
      }

      describe ".call" do
        context "when all is good" do
          it "updates the letter" do
            expect_subject_to_broadcast(:revise_letter_successful, letter)

            subject.call(patient, letter.id, description: "Foo", by: user)
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

              subject.call(patient, letter.id, by: user, topic_id: topic.id)

              expect(letter.section_snapshots.count).to eq 0
            end
          end

          context "when topic has changed" do
            let(:topic) { create(:letter_topic, section_identifiers: [:hd_section]) }
            let(:new_topic) { create(:letter_topic, section_identifiers: [:hd_section]) }

            context "and new topic has sections associated with it" do
              it "generates snapshots for those letter sections" do
                expect(letter.section_snapshots.count).to eq 0

                subject.call(patient, letter.id, by: user, topic_id: new_topic.id)

                expect(letter.section_snapshots.count).to eq 1

                snapshot = letter.section_snapshots.first
                expect(snapshot.section_identifier).to eq "hd_section"
                expect(snapshot.content).to include "<dl></dl>"
              end
            end

            context "when an existing snapshot was already there for this section" do
              let!(:section_snapshot) {
                create(:section_snapshot, letter: letter, content: "test",
                                          section_identifier: "hd_section")
              }

              it "keeps it as it is" do
                expect(letter.section_snapshots.first.content).to eq "test"

                subject.call(patient, letter.id, by: user, topic_id: new_topic.id)

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

              context "and a true value has been passed in" do
                it "updates the snapshot content" do
                  subject.call(patient, letter.id, by: user, update_sections: { hd_section: "1" })
                  expect(section_snapshot.reload.content).to include "<dl></dl>"
                end

                context "and a false value has been passed in" do
                  it "doesn't update" do
                    subject.call(patient, letter.id, by: user, update_sections: { hd_section: "0" })
                    expect(section_snapshot.reload.content).to eq "old content"
                  end
                end
              end
            end

            context "when section snapshots have not existed for this letter" do
              context "and a true value has been passed in" do
                it "creates the snapshot content" do
                  subject.call(patient, letter.id, by: user, update_sections: { hd_section: "1" })

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

            subject.call(patient, letter.id, description: nil, by: nil)
              .on(:revise_letter_failed) do |letter|
                # Those don't work
                expect(letter.description).to eq("TestDescription")
                expect(letter.errors).to eq("TestDescription")
              end
          end
        end
      end

      def expect_subject_to_broadcast(*args)
        expect(subject).to receive(:broadcast).with(*args).and_call_original
      end
    end
  end
end
