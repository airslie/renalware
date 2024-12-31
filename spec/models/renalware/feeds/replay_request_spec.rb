module Renalware::Feeds
  describe ReplayRequest do
    subject { described_class.new }

    let(:patient) { create(:patient) }

    it :aggregate_failures do
      is_expected.to have_many :message_replays
      is_expected.to belong_to :patient
      is_expected.to validate_presence_of(:started_at)
      is_expected.to validate_presence_of(:patient)
    end

    describe "#start_logging" do
      context "when another replay request for the current patient is unfinished" do
        it "returns without yielding" do
          _ongoing_replay = described_class.create!(
            started_at: 1.hour.ago,
            finished_at: nil,
            patient: patient
          )

          expect do |block|
            described_class.start_logging(patient, "bla", &block)
          end.not_to yield_control
        end

        it "creates a new record with a finished_at and an error_message" do
          _ongoing_replay = described_class.create!(
            started_at: 1.hour.ago,
            finished_at: nil,
            patient: patient
          )

          freeze_time do
            described_class.start_logging(patient, "reason")

            replay_request = described_class.last
            expect(replay_request).to have_attributes(
              patient: patient,
              started_at: Time.zone.now,
              finished_at: Time.zone.now
            )
            expect(replay_request.error_message).to match(
              "An unfinished replay found for patient #{patient.id}"
            )
          end
        end
      end
    end
  end
end
