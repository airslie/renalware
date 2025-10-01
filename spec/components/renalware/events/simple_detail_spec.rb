# frozen_string_literal: true

module Renalware
  RSpec.describe Events::SimpleDetail do
    subject { described_class.new(record) }

    let(:record) { build(:simple_event) }

    it "renders component" do
      expect(fragment.text).to include("Description:Needs blood sample taken.")
      expect(fragment.text).to include("Notes:#{record.notes}")
    end
  end
end
