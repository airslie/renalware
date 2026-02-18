module Renalware
  module Letters
    RSpec.describe ReviseLetter do
      include LettersSpecHelper

      subject(:service) { described_class.new }

      let(:user) { create(:user, :minimal) }
      let(:patient) { create(:letter_patient, :minimal) }
      let(:hospital_unit) { create(:hospital_unit, name: "The Unit") }
      let(:topic) { nil }

      let(:letter) {
        create(:draft_letter,
               description: "TestDescription",
               patient: patient,
               topic: topic,
               main_recipient: build(:letter_recipient, :main),
               by: user)
      }
      let(:hd_patient) { patient.becomes(Renalware::HD::Patient) }
      let(:snapshot_html) do
        "<dl><dt>HD Unit</dt><dd>The Unit</dd><dt>HD Duration</dt><dd>3:30</dd></dl>"
      end

      before do
        create(
          :hd_profile,
          patient: hd_patient,
          prescribed_time: 210,
          hospital_unit: hospital_unit
        )
      end

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
            let(:topic) { create(:letter_topic, section_identifier: :hd) }

            it "doesn't generate snapshots" do
              expect(letter.section_snapshots.count).to eq 0

              service.call(patient, letter.id, by: user, topic_id: topic.id)

              expect(letter.section_snapshots.count).to eq 0
            end
          end

          context "when topic has changed" do
            let(:topic) { create(:letter_topic, section_identifier: :hd) }
            let(:new_topic) { create(:letter_topic, section_identifier: :hd) }

            context "when also new topic has sections associated with it" do
              it "generates snapshots for those letter sections" do
                expect(letter.section_snapshots.count).to eq 0

                service.call(patient, letter.id, by: user, topic_id: new_topic.id)

                expect(letter.section_snapshots.count).to eq 1

                snapshot = letter.section_snapshots.first
                expect(snapshot.section_identifier).to eq "hd"
                expect(snapshot.content).to include snapshot_html
              end
            end

            context "when an existing snapshot was already there for this section" do
              let(:snapshot) do
                create(
                  :section_snapshot,
                  letter: letter,
                  content: "test",
                  section_identifier: :hd
                )
              end

              before { snapshot }

              it "keeps it as it is" do
                service.call(patient, letter.id, by: user, topic_id: new_topic.id)

                expect(letter.section_snapshots.count).to eq 1

                expect(snapshot.reload.section_identifier).to eq "hd"
                expect(snapshot.content).to eq "test"
              end
            end
          end

          context 'when "update_sections" is passed as parameter' do
            context "when section snapshots have been previously created" do
              let!(:section_snapshot) {
                create(:section_snapshot, letter: letter, section_identifier: "hd",
                                          content: "old content")
              }

              context "when also a true value has been passed in" do
                it "updates the snapshot content" do
                  service.call(patient, letter.id, by: user, update_sections: { hd: "1" })
                  expect(section_snapshot.reload.content).to include snapshot_html
                end

                context "when also a false value has been passed in" do
                  it "doesn't update" do
                    service.call(patient, letter.id, by: user, update_sections: { hd: "0" })
                    expect(section_snapshot.reload.content).to eq "old content"
                  end
                end
              end
            end

            context "when section snapshots have not existed for this letter" do
              context "when also a true value has been passed in" do
                it "creates the snapshot content" do
                  service.call(patient, letter.id, by: user, update_sections: { hd: "1" })

                  expect(letter.section_snapshots.count).to eq 1

                  snapshot = letter.section_snapshots.first
                  expect(snapshot.section_identifier).to eq "hd"
                  expect(snapshot.content).to include snapshot_html
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
