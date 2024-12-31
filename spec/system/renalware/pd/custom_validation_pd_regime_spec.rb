module Renalware
  describe "Validate for at least one bag per PD regime", :js do
    include PatientsSpecHelper

    it "creating a CAPD regime without a bag should fail validation" do
      patient = create(:patient)
      set_modality(patient: patient,
                   modality_description: create(:pd_modality_description),
                   by: User.first)

      login_as_clinical
      visit patient_pd_dashboard_path(patient)

      within ".page-actions" do
        click_link "Add"
        click_link "CAPD Regime"
      end

      select "CAPD 3 exchanges per day", from: "Treatment"

      click_on t("btn.create")

      expect(page).to have_content("Regime must be assigned at least one bag")
    end
  end
end
