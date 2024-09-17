# frozen_string_literal: true

describe Renalware::Pathology::Requests::GlobalRule::TransplantRegistrationStatus do
  describe "#to_s" do
    subject { described_class.new(param_comparison_value: "S").to_s }

    it { is_expected.to eq("transplant registration status is S") }
  end
end
