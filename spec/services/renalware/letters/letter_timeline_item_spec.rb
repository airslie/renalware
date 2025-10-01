RSpec.describe Renalware::Letters::LetterTimelineItem do
  subject(:item) { described_class.new(id: model.id, sort_date:).fetch }

  let(:sort_date) { Time.zone.now }
  let(:model) { create(:draft_letter) }

  it "returns correct data for timeline" do
    expect(item.id).to eq model.id
    expect(item.sort_date).to eq sort_date
  end
end
