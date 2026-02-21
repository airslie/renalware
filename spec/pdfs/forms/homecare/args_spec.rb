# frozen_string_literal: true

RSpec.describe Forms::Homecare::Args do
  describe "#patient_name" do
    subject {
      hash = default_test_arg_values.update(
        given_name: "John",
        family_name: "SMITH",
        title:
      )
      described_class.new(hash).patient_name
    }

    context "when title present" do
      let(:title) { "Mr" }

      it { is_expected.to eq("SMITH, John (Mr)") }
    end

    context "when title missing" do
      let(:title) { "" }

      it { is_expected.to eq("SMITH, John") }
    end
  end
end
