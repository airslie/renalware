module Renalware
  module HD
    describe CalculateOverallVNDRisk do
      describe "#call" do
        it "score 2 is level low" do
          assessment = VNDRiskAssessment.new(
            risk1: "0_xx",
            risk2: "0_xx",
            risk3: "1_xx",
            risk4: "1_xx"
          )

          expect(described_class.call(assessment)).to eq(
            {
              overall_risk_score: 2,
              overall_risk_level: :low
            }
          )
        end

        it "score 3 is level medium" do
          expect(described_class.call(VNDRiskAssessment.new(risk4: "3_xx"))).to eq(
            {
              overall_risk_score: 3,
              overall_risk_level: :medium
            }
          )
        end

        it "score 4 is level medium" do
          expect(described_class.call(VNDRiskAssessment.new(risk4: "4_xx"))).to eq(
            {
              overall_risk_score: 4,
              overall_risk_level: :medium
            }
          )
        end

        it "score 5 is level high" do
          expect(described_class.call(VNDRiskAssessment.new(risk4: "5_xx"))).to eq(
            {
              overall_risk_score: 5,
              overall_risk_level: :high
            }
          )
        end
      end
    end
  end
end
