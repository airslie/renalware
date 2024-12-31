module Renalware::Feeds
  describe OutgoingDocument do
    it_behaves_like "an Accountable model"

    it :aggregate_failures do
      is_expected.to validate_presence_of(:state)
    end

    describe "state enum" do
      it :aggregate_failures do
        is_expected.to respond_to(:queued?)
        is_expected.to respond_to(:errored?)
        is_expected.to respond_to(:processed?)
      end
    end

    describe "#queued_for_processing scope" do
      it "returns queued items in FIFO order (oldest first)" do
        user = create(:user)
        event = create(:swab)
        queued_ev1 = described_class.create!(renderable: event, by: user, created_at: 1.day.ago)
        queued_ev2 = described_class.create!(renderable: event, by: user, created_at: 10.days.ago)
        described_class.create!(renderable: event, by: user, state: :processed)

        items = described_class.queued_for_processing

        expect(items.map(&:id)).to eq([queued_ev2.id, queued_ev1.id])
      end
    end
  end
end
