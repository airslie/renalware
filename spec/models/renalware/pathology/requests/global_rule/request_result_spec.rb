describe Renalware::Pathology::Requests::GlobalRule::RequestResult do
  let(:klass) { described_class }

  describe "#request_description_present" do
    include_context "with a global_rule_set"

    context "with a valid request_description" do
      subject(:global_rule) do
        klass.new(
          rule_set: global_rule_set,
          param_id: request_description_for_global_rule.id,
          param_comparison_operator: ">",
          param_comparison_value: 100
        )
      end

      let!(:observation_description_for_global_rule) do
        build_stubbed(:pathology_observation_description)
      end
      let!(:request_description_for_global_rule) do
        create(
          :pathology_request_description,
          required_observation_description: observation_description_for_global_rule
        )
      end

      it { expect(global_rule).to be_valid }
    end

    context "with an invalid request_description" do
      subject(:global_rule) do
        klass.new(
          rule_set: global_rule_set,
          param_id: request_description_for_global_rule,
          param_comparison_operator: ">",
          param_comparison_value: 100
        )
      end

      let!(:request_description_for_global_rule) do
        create(
          :pathology_request_description,
          required_observation_description: nil
        )
      end

      it { expect(global_rule).not_to be_valid }
    end

    context "with no request_description" do
      subject(:global_rule) do
        klass.new(
          rule_set: global_rule_set,
          param_id: nil,
          param_comparison_operator: ">",
          param_comparison_value: 100
        )
      end

      it { expect(global_rule).not_to be_valid }
    end
  end
end
