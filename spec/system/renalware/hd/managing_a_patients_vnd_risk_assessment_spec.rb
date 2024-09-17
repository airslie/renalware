# frozen_string_literal: true

describe "Managing a patient's Venal Needle Dislodgment (VND) risk assessment" do
  include PatientsSpecHelper

  it "adding a VND risk assessment" do
    user = login_as_clinical
    patient = create(:hd_patient, by: user)
    visit patient_hd_dashboard_path(patient)
    within ".page-actions" do
      click_on t("btn.add")
      click_on "VND Assessment"
    end

    choose("assessment_params[risk1]", option: "0_very_low")
    choose("assessment_params[risk2]", option: "0_low")
    choose("assessment_params[risk3]", option: "2_medium")
    choose("assessment_params[risk4]", option: "2_high")

    within(".form-actions") do
      click_on "Create"
    end

    vnd_risk_assessment = patient.vnd_risk_assessments.first
    expect(vnd_risk_assessment).to have_attributes(
      risk1: "0_very_low",
      risk2: "0_low",
      risk3: "2_medium",
      risk4: "2_high",
      overall_risk_score: 4
    )
  end
end
