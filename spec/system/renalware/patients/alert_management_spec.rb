# frozen_string_literal: true

describe "Alert management" do
  include AjaxHelpers

  it "A clinician adds an alert to a patient", js: true do
    user = login_as_clinical
    patient = create(:patient, by: user)

    visit patient_path(patient)

    click_on "Create alert"

    within "#create-alert-modal" do
      fill_in "Notes", with: "Some note"
      choose "URGENT"
      click_on "Create alert"
    end

    wait_for_ajax
    within ".patient-alerts" do
      expect(page).to have_content("Some note")
      expect(page).to have_css(".patient-alert", count: 1)
    end
  end

  it "A clinician deletes an alert", js: true do
    user = login_as_clinical
    patient = create(:patient, by: user)
    create(:patient_alert,
           patient: patient,
           by: user,
           notes: "Abc")

    visit patient_path(patient)

    within ".patient-alerts" do
      expect(page).to have_content("Abc")
      expect(page).to have_css(".patient-alert", count: 1)
    end

    within ".patient-alerts" do
      # Prevent alert from popping up i.e. auto accept it.
      page.execute_script("window.confirm = function(){ return true; }")
      find(".actions a").click
      wait_for_ajax
      expect(page).to have_css(".patient-alert", count: 0)
    end
  end
end
