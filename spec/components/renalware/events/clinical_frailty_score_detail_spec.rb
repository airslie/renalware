# frozen_string_literal: true

module Renalware
  RSpec.describe Events::ClinicalFrailtyScoreDetail do
    subject { described_class.new(record) }

    let(:record) { build(:clinical_frailty_score) }

    it "renders component" do
      expect(fragment.text).to include("Score:1. Very Fit")
      expect(fragment.text).to include("Notes:#{record.notes}")
    end
  end
end
