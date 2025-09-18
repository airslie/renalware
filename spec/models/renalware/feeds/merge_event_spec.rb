describe Renalware::Feeds::MergeEvent do
  subject(:merge_event) { build(:feed_merge_event) }

  it "has a valid factory" do
    expect(merge_event).to be_valid
    merge_event.save!
  end

  it :aggregate_failures do
    is_expected.to validate_presence_of(:major_patient)
    is_expected.to validate_presence_of(:minor_patient)
    is_expected.to validate_presence_of(:event_type)
    is_expected.to validate_presence_of(:status)
  end

  describe "status enum default" do
    it "is in_progress" do
      expect(merge_event.status).to eq("in_progress")
    end
  end
end
