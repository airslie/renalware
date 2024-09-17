# frozen_string_literal: true

describe "Managing needling assessments" do
  include DateHelpers

  it "allows adding a new needling assessment" do
    user = login_as_clinical
    patient = create(:accesses_patient, by: user)
    visit patient_accesses_dashboard_path(patient)

    within ".page-actions" do
      click_on t("btn.add")
      click_on t("renalware.accesses.dashboards.page_actions.needling_assessment")
    end

    expect(page).to have_current_path new_patient_accesses_needling_assessment_path(patient)
    expect(page).to have_content "New Ease of Needling (MAGIC)"

    within("#new_needling_assessment") do
      select "Moderate", from: "Difficulty"
      click_on "Create"
    end

    expect(page).to have_current_path patient_accesses_dashboard_path(patient)
  end

  it "allows a superadmin to delete an assessment - see policy tests also" do
    user = login_as_super_admin
    patient = create(:accesses_patient, by: user)
    assessment = create(
      :access_needling_assessment,
      patient: patient,
      by: user,
      created_at: "12-Apr-2021"
    )
    visit patient_accesses_dashboard_path(patient)
    click_on t("btn.delete", context: "##{dom_id(assessment)}")

    expect(page).to have_current_path patient_accesses_dashboard_path(patient)
    expect(page).to have_no_css("##{dom_id(assessment)}")
  end
end
