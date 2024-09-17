# frozen_string_literal: true

module Renalware
  module HD
    describe VNDRiskAssessment do
      it_behaves_like "an Accountable model"
      it_behaves_like "a Paranoid model"
      it :aggregate_failures do
        is_expected.to validate_presence_of(:patient)
        is_expected.to validate_presence_of(:risk1)
        is_expected.to validate_presence_of(:risk2)
        is_expected.to validate_presence_of(:risk3)
        is_expected.to validate_presence_of(:risk4)
        is_expected.to belong_to(:patient)
      end

      describe "#overall_risk_score" do
        it "sums risks 1 to 4 when saved" do
          user = create(:user)
          patient = create(:hd_patient, by: user)
          assessment = described_class.create!(
            patient: patient,
            risk1: "0_very_low",
            risk2: "0_low",
            risk3: "1_low",
            risk4: "2_high",
            by: user
          )

          expect(assessment.overall_risk_score).to eq(3)
        end
      end

      describe "#overall_risk_level" do
        it "is deduced based on the overall_risk_score score" do
          user = create(:user)
          patient = create(:hd_patient, by: user)
          assessment = described_class.create!(
            patient: patient,
            risk1: "0_very_low",
            risk2: "0_low",
            risk3: "1_low",
            risk4: "2_high",
            by: user
          )

          expect(assessment.overall_risk_level).to eq("medium")
        end
      end

      describe "#overall_risk" do
        it "concatenates score and level" do
          assessment = described_class.new(overall_risk_score: 1, overall_risk_level: "low")

          expect(assessment.overall_risk).to eq("1 Low")
        end
      end

      describe "current scope" do
        it "returns nil if there are no assessments" do
          user = create(:user)
          patient = create(:hd_patient, by: user)

          expect(patient.vnd_risk_assessments.current).to be_nil
        end

        it "returns the one and only assessment if there is only one" do
          user = create(:user)
          patient = create(:hd_patient, by: user)

          assessment = create(:hd_vnd_risk_assessment, patient: patient, by: user)

          expect(patient.vnd_risk_assessments.current).to eq(assessment)
        end

        it "return the latest if there are > 1" do
          user = create(:user)
          patient = create(:hd_patient, by: user)
          args = { patient: patient, by: user }
          create(:hd_vnd_risk_assessment, updated_at: "2023-01-01", **args)
          target_assessment = create(:hd_vnd_risk_assessment, updated_at: "2023-03-01", **args)
          create(:hd_vnd_risk_assessment, updated_at: "2023-02-01", **args)

          expect(patient.vnd_risk_assessments.current.id).to eq(target_assessment.id)
        end
      end
    end
  end
end
