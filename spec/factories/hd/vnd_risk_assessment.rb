FactoryBot.define do
  factory :hd_vnd_risk_assessment, class: "Renalware::HD::VNDRiskAssessment" do
    accountable
    patient
    risk1 { "0_very_low" }
    risk2 { "0_low" }
    risk3 { "1_medium" }
    risk4 { "2_high" }
  end
end
