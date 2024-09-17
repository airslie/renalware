# frozen_string_literal: true

describe "Editing an Access Plan" do
  include DateHelpers

  # Note editing is actually a create using the current plan as a template.
  # There is no update action
  it "A clinician edits an existing Access Plan causing a new current plan to be created " \
     "and the previous one to be terminated" do
    user = login_as_clinical
    patient = create(:accesses_patient, by: user)
    create(:access_plan,
           patient: patient,
           notes: "Original notes",
           by: user)

    visit patient_accesses_dashboard_path(patient)

    expect(page).to have_css(".access-plans .current-access-plan")
    expect(page).to have_css(".historical-access-plans table tbody tr", count: 1)

    within ".access-plans header" do
      click_on t("btn.edit")
    end

    within "#new_accesses_plan" do
      fill_in "Notes", with: "Changed notes"
      # Other data should be pre-populated as per the plan we are cloning
      click_on t("btn.create")
    end

    expect(page).to have_current_path(patient_accesses_dashboard_path(patient))

    within ".access-plans .current-access-plan" do
      expect(page).to have_content("Changed notes")
    end

    within ".access-plans .historical-access-plans" do
      expect(page).to have_content("Original notes")
    end
  end

  # Note editing is actually a create using the current plan as a template.
  # There is no update action
  it "A clinician edits an Access Plan without changing any data, causing no new Plan " \
     "to be created" do
    user = login_as_clinical
    patient = create(:accesses_patient, by: user)
    create(:access_plan,
           patient: patient,
           notes: "Original notes",
           by: user)

    visit patient_accesses_dashboard_path(patient)

    expect(page).to have_css(".historical-access-plans table tbody tr", count: 1)

    within ".access-plans header" do
      click_on t("btn.edit")
    end

    within "#new_accesses_plan" do
      click_on t("btn.create")
    end

    expect(page).to have_current_path(patient_accesses_dashboard_path(patient))
    expect(page).to have_css(".historical-access-plans table tbody tr", count: 1)
  end
end
