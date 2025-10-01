RSpec.describe Renalware::Messaging::Internal::MessageTimelineItem do
  subject(:item) { described_class.new(id: model.id, sort_date:).fetch }

  let(:sort_date) { Time.zone.now }
  let(:model) { create(:internal_message) }

  it "returns correct data for timeline" do
    expect(item.id).to eq model.id
    expect(item.sort_date).to eq sort_date
  end
end
