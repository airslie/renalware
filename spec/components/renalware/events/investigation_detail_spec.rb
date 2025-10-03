# frozen_string_literal: true

module Renalware
  RSpec.describe Events::InvestigationDetail do
    subject { described_class.new(record) }

    let(:record) { build(:investigation) }

    it "renders component" do
      expect(fragment.text).to include("Modality:Other")
      expect(fragment.text).to include("Type:24 hr Urinary Stone Screen")
      expect(fragment.text).to include("Result:result")
      expect(fragment.text).to include("Notes:#{record.notes}")
    end
  end
end
