# frozen_string_literal: true

describe Renalware::Pathology::Requests::PatientAlgorithm do
  subject(:patient_algorithm) do
    described_class.new(pathology_patient)
  end

  let(:patient) { build(:patient) }
  let(:pathology_patient) { Renalware::Pathology.cast_patient(patient) }

  let(:required_rule) do
    build(:pathology_requests_patient_rule, patient: pathology_patient)
  end
  let(:not_required_rule) do
    build(:pathology_requests_patient_rule, patient: pathology_patient)
  end
  let(:rules) { [required_rule, not_required_rule] }

  describe "#determine_required_tests" do
    subject(:required_tests) { patient_algorithm.determine_required_tests }

    before do
      allow(Renalware::Pathology).to receive(:cast_patient).and_return(pathology_patient)
      allow(pathology_patient).to receive(:rules).and_return(rules)
      allow(required_rule).to receive(:required?).and_return(true)
      allow(not_required_rule).to receive(:required?).and_return(false)
    end

    it "returns the required rules" do
      expect(required_tests).to eq([required_rule])
    end
  end
end
