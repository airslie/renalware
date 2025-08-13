# frozen_string_literal: true

RSpec.describe Shared::DescriptionList do
  subject(:component) do
    described_class.new do
      Shared::DescriptionListItem(key, value)
    end
  end

  let(:key) { "Label" }
  let(:value) { "value" }

  it "renders component" do
    expect(fragment.css("dl.dl-horizontal dt").text).to eq("Label")
    expect(fragment.css("dl.dl-horizontal dd").text).to eq("value")
  end
end
