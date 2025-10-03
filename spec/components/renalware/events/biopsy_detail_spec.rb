# frozen_string_literal: true

module Renalware
  RSpec.describe Events::BiopsyDetail do
    subject { described_class.new(record) }

    let(:record) { build(:biopsy) }

    it "renders component" do
      expect(fragment.text).to include("Rejection:Acute AMR")
      expect(fragment.text).to include("IFTA:>50%")
      expect(fragment.text).to include("Notes:#{record.notes}")
    end
  end
end
