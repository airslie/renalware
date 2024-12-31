module Renalware::System
  describe ViewCall do
    it { is_expected.to belong_to(:view_metadata).counter_cache(:calls_count) }
    it { is_expected.to belong_to(:user) }

    it "updates counter_cache on view_metadata when a saved" do
      freeze_time do
        view_metadata = create(:view_metadata)
        user = create(:user)

        described_class.create!(user: user, view_metadata: view_metadata, called_at: Time.zone.now)

        expect(view_metadata.reload).to have_attributes(
          calls_count: 1,
          last_called_at: Time.zone.now
        )
      end
    end
  end
end
