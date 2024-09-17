# frozen_string_literal: true

describe Renalware::Pathology::Requests::GlobalRule::ObservationResult do
  let(:klass) { described_class }

  describe "#observation_description_present" do
    include_context "with a global_rule_set"

    context "with a valid observation_description" do
      subject(:global_rule) do
        klass.new(
          rule_set: global_rule_set,
          param_id: observation_description.id,
          param_comparison_operator: "<",
          param_comparison_value: 100
        )
      end

      let(:observation_description) { build_stubbed(:pathology_observation_description) }

      it { expect(global_rule).to be_valid }
    end

    context "with an invalid observation_description" do
      subject(:global_rule) do
        klass.new(
          rule_set: global_rule_set,
          param_id: nil,
          param_comparison_operator: "<",
          param_comparison_value: 100
        )
      end

      it { expect(global_rule).not_to be_valid }
    end
  end
end
