# frozen_string_literal: true

describe Renalware::Pathology::Requests::GlobalRule::PrescriptionDrugType do
  let(:drug_type) { create(:drug_type) }

  describe "#drug_type_present" do
    include_context "with a global_rule_set"

    context "with a valid drug_type" do
      subject do
        described_class.new(
          rule_set: global_rule_set,
          param_id: drug_type.id,
          param_comparison_operator: nil,
          param_comparison_value: nil
        )
      end

      it { is_expected.to be_valid }
    end

    context "with an invalid drug_type" do
      subject do
        described_class.new(
          rule_set: global_rule_set,
          param_id: nil,
          param_comparison_operator: nil,
          param_comparison_value: nil
        )
      end

      it { is_expected.not_to be_valid }
    end
  end

  describe "#observation_required_for_patient?" do
    subject do
      described_class.new(
        rule_set: global_rule_set,
        param_id: drug_type.id,
        param_comparison_operator: nil,
        param_comparison_value: nil
      ).observation_required_for_patient?(patient, nil)
    end

    include_context "with a global_rule_set"

    let(:drug_type) { create(:drug_type) }
    let(:patient) { create(:pathology_patient) }
    let(:required_drug) { create(:drug, name: "target drug") }
    let(:other_drug) { create(:drug, name: "other drug") }

    context "when then the patient has no drugs" do
      it { is_expected.to be(false) }
    end

    context "when then the patient has a drug not of the required type" do
      before { create(:prescription, drug: other_drug, patient: patient) }

      it { is_expected.to be(false) }
    end

    context "when then the patient has a drug of the required type" do
      before {
        drug_type.drugs << required_drug
        create(:prescription, drug: required_drug, patient: patient)
      }

      it { is_expected.to be(true) }
    end

    context "when then the patient has the required drug but it has been terminated" do
      before do
        drug_type.drugs << required_drug
        create(:prescription, drug: required_drug, patient: patient).tap do |prescription|
          create(:prescription_termination, prescription: prescription, terminated_on: 1.day.ago)
        end
      end

      it { is_expected.to be(false) }
    end
  end
end
