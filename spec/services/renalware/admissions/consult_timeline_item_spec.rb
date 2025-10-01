RSpec.describe Renalware::Admissions::ConsultTimelineItem do
  subject(:item) { described_class.new(id: model.id, sort_date:).fetch }

  let(:sort_date) { Time.zone.now }
  let(:model) { create(:admissions_consult) }

  it "returns correct data for timeline" do
    expect(item.id).to eq model.id
    expect(item.sort_date).to eq sort_date
  end

  it "loads the consult record with associations" do
    expect(item.record).to eq model
    expect { item.record.patient }.not_to raise_error
    expect { item.record.consult_site }.not_to raise_error
    expect { item.record.hospital_ward }.not_to raise_error
  end
end
