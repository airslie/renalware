# frozen_string_literal: true

module Renalware
  RSpec.describe Events::AdvancedCarePlanDetail do
    subject { described_class.new(record) }

    let(:record) { build(:advanced_care_plan, notes: nil) }

    it "renders component" do
      expect(fragment.text).to include("State:ACP not required")
      expect(fragment.text).to include("Notes:Not specified")
    end
  end
end
