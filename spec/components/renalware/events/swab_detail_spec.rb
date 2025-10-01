# frozen_string_literal: true

module Renalware
  RSpec.describe Events::SwabDetail do
    subject { described_class.new(record) }

    let(:record) { build(:swab) }

    it "renders component" do
      expect(fragment.text).to include("Site:The location")
      expect(fragment.text).to include("Notes:#{record.notes}")
    end
  end
end
