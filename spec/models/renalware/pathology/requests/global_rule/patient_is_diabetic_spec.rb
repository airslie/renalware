# frozen_string_literal: true

describe Renalware::Pathology::Requests::GlobalRule::PatientIsDiabetic do
  def rule_for(value, patient)
    described_class
      .new(param_comparison_value: value)
      .observation_required_for_patient?(patient, Date.current)
  end

  let(:value) { "true" }

  describe "#observation_required_for_patient?" do
    context "when the patient is diabetic" do
      def patient
        instance_double(Renalware::Patient, diabetic?: true)
      end

      %w(true True TRUE).each do |boolean_string|
        it do
          expect(rule_for(boolean_string, patient)).to be(true)
        end
      end

      %w(false AnyString).each do |boolean_string|
        it do
          expect(rule_for(boolean_string, patient)).to be(false)
        end
      end
    end

    context "when the patient is NOT diabetic" do
      def patient
        instance_double(Renalware::Patient, diabetic?: false)
      end

      %w(true True TRUE).each do |boolean_string|
        it do
          expect(rule_for(boolean_string, patient)).to be(false)
        end
      end

      %w(false AnyString).each do |boolean_string|
        it do
          expect(rule_for(boolean_string, patient)).to be(true)
        end
      end
    end
  end
end
