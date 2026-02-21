# frozen_string_literal: true

RSpec.describe Shared::DescriptionListItem do
  subject(:component) { described_class.new(key, value, title:) }

  let(:key) { "Label" }
  let(:value) { "value" }
  let(:title) { "title" }

  it "renders component" do
    expect(fragment.css("dt[title=#{title}]")).not_to be_empty
    expect(fragment.css("dt").text).to eq(key)
    expect(fragment.css("dd").text).to eq(value)
  end

  it "removes title from attributes" do
    fragment
    expect(component.attrs[:title]).to be_nil
  end

  context "when value not present" do
    let(:value) { nil }

    it "renders component" do
      expect(fragment.css("dd").text).to eq "Not specified"
    end
  end

  context "when value is HTML" do
    let(:value) { "<p>value</p>" }

    it "renders component" do
      expect(response).to include(value)
    end
  end
end
