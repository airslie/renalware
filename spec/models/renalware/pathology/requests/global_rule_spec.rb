# frozen_string_literal: true

describe Renalware::Pathology::Requests::GlobalRule do
  subject(:global_rule) do
    build(
      :pathology_requests_global_rule,
      type: nil,
      rule_set: global_rule_set
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

  let(:global_rule_set) do
    build(
      :pathology_requests_global_rule_set,
      clinic: clinic,
      frequency_type: "Once",
      request_description: request_description
    )
  end

  it { is_expected.to validate_presence_of(:rule_set) }

  describe "#observation_required_for_patient?" do
    let(:patient) { build(:patient) }

    it "raises NotImplementedError" do
      expect {
        global_rule.observation_required_for_patient?(patient, Date.current)
      }.to raise_error(NotImplementedError)
    end
  end

  describe "#to_s?" do
    it "raises NotImplementedError" do
      expect { global_rule.to_s }.to raise_error(NotImplementedError)
    end
  end
end
