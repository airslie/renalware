describe Renalware::Pathology::Requests::GlobalRuleSet do
  subject(:global_rule_set) do
    build(
      :pathology_requests_global_rule_set,
      clinic: clinic,
      frequency_type: "Once",
      request_description: request_description,
      rules: rules
    )
  end

  let(:clinic) { build(:clinic) }
  let(:observation_description) { build(:pathology_observation_description) }
  let(:request_description) do
    build(
      :pathology_request_description,
      required_observation_description: observation_description,
      bottle_type: "serum"
    )
  end
  let(:rules) { [] }

  describe "#valid?" do
    context "without a request_description" do
      let(:request_description) { nil }

      it { expect(global_rule_set).not_to be_valid }
    end

    context "with a request_description" do
      context "without a required_observation_description" do
        let(:request_description) { build(:pathology_request_description, bottle_type: "serum") }

        it { expect(global_rule_set).not_to be_valid }
      end

      context "without a bottle_type" do
        let(:observation_description) { build(:pathology_observation_description) }
        let(:request_description) do
          build(
            :pathology_request_description,
            required_observation_description: observation_description
          )
        end

        it { expect(global_rule_set).not_to be_valid }
      end

      context "with the necessary fields set" do
        let(:observation_description) { build(:pathology_observation_description) }
        let(:request_description) do
          build(
            :pathology_request_description,
            required_observation_description: observation_description,
            bottle_type: "serum"
          )
        end

        it { expect(global_rule_set).to be_valid }
      end
    end
  end

  describe "#to_s" do
    context "with no rules" do
      it "returns the frequency" do
        expect(global_rule_set.to_s).to eq(global_rule_set.frequency.to_s)
      end
    end

    context "with one rule" do
      let(:rule_str) { "the sky is blue" }
      let(:rule) { build(:pathology_requests_global_rule) }
      let(:rules) { [rule] }

      before do
        allow(rule).to receive(:to_s).and_return(rule_str)
      end

      it "returns the rule and the frequency" do
        expect(global_rule_set.to_s).to include(rule_str, global_rule_set.frequency.to_s)
      end
    end

    context "with two rules" do
      let(:rule_str1) { "the sky is blue" }
      let(:rule1) { build(:pathology_requests_global_rule) }
      let(:rule_str2) { "the grass is green" }
      let(:rule2) { build(:pathology_requests_global_rule) }
      let(:rules) { [rule1, rule2] }

      before do
        allow(rule1).to receive(:to_s).and_return(rule_str1)
        allow(rule2).to receive(:to_s).and_return(rule_str2)
      end

      it "returns the rule and the frequency" do
        expect(global_rule_set.to_s).to include(
          rule_str1, rule_str2, global_rule_set.frequency.to_s
        )
      end
    end
  end
end
