# frozen_string_literal: true

describe "Creating an Access Plan" do
  include DateHelpers

  it "A clinician adds the first access plan to a patient using menus" do
    user = login_as_clinical
    patient = create(:accesses_patient, by: user)
    plan_type = create(:access_plan_type, name: "Continue dialysis line")
    notes = "Lorem ipsum delor"

    visit patient_accesses_dashboard_path(patient)

    expect(page).to have_no_content("Plan History")

    within ".page-actions" do
      click_on t("btn.add")
      click_on t("renalware.accesses.dashboards.page_actions.access_plan")
    end

    within "#new_accesses_plan" do
      select plan_type.name, from: "Plan"
      select user.to_s, from: "Decided by"
      fill_in "Notes", with: notes
      click_on t("btn.create")
    end

    expect(page).to have_current_path(patient_accesses_dashboard_path(patient))

    within ".access-plans .current-access-plan" do
      expect(page).to have_content(plan_type.name)
      expect(page).to have_content(notes)
      expect(page).to have_content(todays_date)
    end
  end

  it "A clinician adds an plan to a patient, implicitly terminating the previous one" do
    user = login_as_clinical

    patient = create(:accesses_patient, by: user)
    plan_type1 = create(:access_plan_type, name: "Continue dialysis line")
    plan_type2 = create(:access_plan_type, name: "Continue with fistula/graft -- line in situ")
    create(:access_plan,
           patient: patient,
           plan_type: plan_type1,
           by: user)
    notes = "Lorem ipsum delor.."

    visit new_patient_accesses_plan_path(patient)

    within "#new_accesses_plan" do
      select plan_type2.name, from: "Plan"
      fill_in "Notes", with: notes
      select user.to_s, from: "Decided by"
      click_on t("btn.create")
    end

    expect(page).to have_current_path(patient_accesses_dashboard_path(patient))

    within ".access-plans .current-access-plan" do
      expect(page).to have_content(plan_type2.name)
      expect(page).to have_content(notes)
      expect(page).to have_content(todays_date)
    end

    within ".access-plans .historical-access-plans" do
      expect(page).to have_content(plan_type1.name)
    end
  end

  it "A clinician attempts to add a plan to a patient with invalid data" do
    user = login_as_clinical
    patient = create(:accesses_patient, by: user)
    visit new_patient_accesses_plan_path(patient)

    expect(page).to have_no_css(".error")

    within "#new_accesses_plan" do
      click_on t("btn.create")
    end

    expect(page.status_code).to eq(200)
    expect(page).to have_css(".error")
  end
end
