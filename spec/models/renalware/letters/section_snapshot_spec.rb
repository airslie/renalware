module Renalware
  RSpec.describe Letters::SectionSnapshot do
    let(:user) { create(:user, :minimal) }
    let(:patient) { build(:letter_patient) }
    let(:letter) {
      create(:draft_letter,
             topic:,
             patient:,
             main_recipient: build(:letter_recipient, :main),
             by: user)
    }

    let(:topic) { build(:letter_topic, section_identifier: :hd) }
    let(:hd_patient) { patient.becomes(Renalware::HD::Patient) }
    let(:hospital_unit) { create(:hospital_unit, name: "The Unit") }
    let(:snapshot_html) do
      "<dl><dt>HD Unit</dt><dd>The Unit</dd><dt>HD Duration</dt><dd>3:30</dd></dl>"
    end

    before do
      create(
        :hd_profile,
        patient: hd_patient,
        prescribed_time: 210,
        hospital_unit:
      )
    end

    it do
      is_expected.to validate_inclusion_of(:section_identifier)
        .in_array(LETTER_SECTION_IDENTIFIERS)
    end

    describe ".create_or_update" do
      context "when a snapshot doesn't exists" do
        it "creates it" do
          described_class.create_or_update(letter, :hd)

          expect(letter.section_snapshots.count).to eq 1

          snapshot = letter.section_snapshots.first
          expect(snapshot.section_identifier).to eq "hd"
          expect(snapshot.content).to include snapshot_html
        end
      end

      context "when a snapshot already exists" do
        let(:snapshot) do
          create(:section_snapshot, letter:, content: "xy", section_identifier: :hd)
        end

        before { snapshot }

        it "updates it" do
          expect(letter.section_snapshots.count).to eq 1

          described_class.create_or_update(letter, :hd)

          expect(snapshot.reload.section_identifier).to eq "hd"
          expect(snapshot.content).to include snapshot_html
        end

        context "when not supplied a section_identifier" do
          it "uses the topic section_identifier" do
            described_class.create_or_update(letter)

            expect(letter.section_snapshots.first.section_identifier).to eq "hd"
            expect(snapshot.reload.content).to include snapshot_html
          end
        end
      end
    end
  end
end
