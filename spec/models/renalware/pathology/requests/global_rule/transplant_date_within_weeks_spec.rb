# frozen_string_literal: true

describe Renalware::Pathology::Requests::GlobalRule::TransplantDateWithinWeeks do
  describe "#to_s" do
    subject { described_class.new(param_comparison_value: 12).to_s }

    it { is_expected.to eq("transplant date within 12 weeks ago") }
  end
end
