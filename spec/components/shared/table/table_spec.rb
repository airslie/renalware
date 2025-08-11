# frozen_string_literal: true

RSpec.describe Shared::Table do
  subject { described_class.new }

  it "renders component" do
    expect(fragment.css("table.plx")).to be_present
  end
end
