# frozen_string_literal: true

require "rails_helper"

describe Renalware::Pathology::Requests::GlobalRule::PrescriptionDrugCategory do
  let(:drug_category) { create(:pathology_requests_drug_category) }

  describe "#drug_category_present" do
    include_context "a global_rule_set"

    context "with a valid drug_category" do
      subject do
        described_class.new(
          rule_set: global_rule_set,
          param_id: drug_category.id,
          param_comparison_operator: nil,
          param_comparison_value: nil
        )
      end

      it { is_expected.to be_valid }
    end

    context "with an invalid drug_category" do
      subject do
        described_class.new(
          rule_set: global_rule_set,
          param_id: nil,
          param_comparison_operator: nil,
          param_comparison_value: nil
        )
      end

      it { is_expected.to be_invalid }
    end
  end
end
