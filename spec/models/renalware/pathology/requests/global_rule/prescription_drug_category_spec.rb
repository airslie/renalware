# frozen_string_literal: true

describe Renalware::Pathology::Requests::GlobalRule::PrescriptionDrugCategory do
  describe "#drug_category_present" do
    include_context "with a global_rule_set"
    let(:drug_category) { create(:pathology_requests_drug_category) }

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

      it { is_expected.not_to be_valid }
    end
  end

  describe "#observation_required_for_patient?" do
    subject do
      described_class.new(
        rule_set: global_rule_set,
        param_id: drug_category.id,
        param_comparison_operator: nil,
        param_comparison_value: nil
      ).observation_required_for_patient?(patient, nil)
    end

    include_context "with a global_rule_set"

    let(:drug_category) { create(:pathology_requests_drug_category) }
    let(:patient) { create(:pathology_patient) }
    let(:required_drug) { Renalware::Pathology::Requests::Drug.create!(name: "target drug") }
    let(:other_drug) { Renalware::Pathology::Requests::Drug.create!(name: "other drug") }

    context "when then the patient has no drugs" do
      it { is_expected.to be(false) }
    end

    context "when then the patient has a drug not in the required category" do
      before { create(:prescription, drug: other_drug, patient: patient) }

      it { is_expected.to be(false) }
    end

    context "when then the patient has a drug in the required category" do
      before {
        drug_category.drugs << required_drug
        create(:prescription, drug: required_drug, patient: patient)
      }

      it { is_expected.to be(true) }
    end

    context "when then the patient has the required drug but it has been terminated" do
      before do
        drug_category.drugs << required_drug
        create(:prescription, drug: required_drug, patient: patient).tap do |prescription|
          create(:prescription_termination, prescription: prescription, terminated_on: 1.day.ago)
        end
      end

      it { is_expected.to be(false) }
    end
  end
end
