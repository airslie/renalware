RSpec.describe Renalware::Events::EventTimelineItem do
  subject(:item) { described_class.new(id: model.id, sort_date:).fetch }

  let(:sort_date) { Time.zone.now }
  let(:event_type) { create(:event_type, name: "Simple") }
  let(:model) { create(:simple_event, event_type:) }

  it "returns correct data for timeline" do
    expect(item.id).to eq model.id
    expect(item.sort_date).to eq sort_date
  end
end
