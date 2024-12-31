describe Renalware::Pathology::Requests::GlobalRule::PrescriptionDrug do
  describe "#drug_present" do
    include_context "with a global_rule_set"

    context "with a valid drug" do
      subject(:global_rule) do
        described_class.new(
          rule_set: global_rule_set,
          param_id: drug.id,
          param_comparison_operator: nil,
          param_comparison_value: nil
        )
      end

      let!(:drug) { create(:drug) }

      it { expect(global_rule).to be_valid }
    end

    context "with an invalid drug" do
      subject(:global_rule) do
        described_class.new(
          rule_set: global_rule_set,
          param_id: nil,
          param_comparison_operator: nil,
          param_comparison_value: nil
        )
      end

      it { expect(global_rule).not_to be_valid }
    end
  end

  describe "#observation_required_for_patient?" do
    subject do
      described_class.new(
        rule_set: global_rule_set,
        param_id: required_drug.id,
        param_comparison_operator: nil,
        param_comparison_value: nil
      ).observation_required_for_patient?(patient, nil)
    end

    include_context "with a global_rule_set"

    let(:patient) { create(:pathology_patient) }
    let(:required_drug) { create(:drug, name: "required") }
    let(:other_drug) { create(:drug, name: "other") }

    context "when then the patient has no drugs" do
      it { is_expected.to be(false) }
    end

    context "when then the patient has not have the required drug" do
      before { create(:prescription, drug: other_drug, patient: patient) }

      it { is_expected.to be(false) }
    end

    context "when then the patient has the required drug" do
      before { create(:prescription, drug: required_drug, patient: patient) }

      it { is_expected.to be(true) }
    end

    context "when then the patient has the required drug but it has been terminated" do
      before do
        create(:prescription, drug: required_drug, patient: patient).tap do |prescription|
          create(:prescription_termination, prescription: prescription, terminated_on: 1.day.ago)
        end
      end

      it { is_expected.to be(false) }
    end
  end
end
