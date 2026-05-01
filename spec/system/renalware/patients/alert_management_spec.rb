RSpec.describe "Alert management" do
  it "A clinician adds an alert to a patient", :js do
    user = login_as_clinical
    patient = create(:patient, by: user)

    visit patient_path(patient)

    click_on "Create alert"

    within "#create-alert-modal" do
      fill_in "Notes", with: "Some note"
      choose "URGENT"
      click_on "Create alert"
    end

    within ".patient-alerts" do
      expect(page).to have_text("Some note")
      expect(page).to have_css(".patient-alert", count: 1)
    end
  end

  it "A clinician deletes an alert", :js do
    user = login_as_clinical
    patient = create(:patient, by: user)
    create(:patient_alert,
           patient:,
           by: user,
           notes: "Abc")

    visit patient_path(patient)

    within ".patient-alerts" do
      expect(page).to have_text("Abc")
      expect(page).to have_css(".patient-alert", count: 1)
    end

    within ".patient-alerts" do
      # Prevent alert from popping up i.e. auto accept it.
      page.execute_script("window.confirm = function(){ return true; }")
      find(".actions a").click

      expect(page).to have_css(".patient-alert", count: 0)
    end
  end
end
