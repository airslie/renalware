describe "Renal Profile", :js do
  describe "GET #show" do
    it "updating the renal profile" do
      Renalware.config.use_rolling_comorbidities = false
      user = login_as_clinical
      prd = create(:prd_description, term: "PRD1")

      esrf_date = "24-Mar-2017"
      patient = create(:renal_patient, by: user)
      profile = patient.build_profile
      profile.esrf_on = esrf_date
      profile.save!

      visit patient_path(patient)
      within ".side-nav" do
        click_on "Renal Profile"
      end

      # Renal profile #show
      expect(page).to have_current_path(patient_renal_profile_path(patient))
      expect(page).to have_content(esrf_date)

      within ".page-actions" do
        click_on t("btn.edit")
      end

      # Renal profile #edit
      expect(page).to have_current_path(edit_patient_renal_profile_path(patient))

      updated_esrf_date = "25-Mar-2016"
      fill_in "ESRF Date", with: updated_esrf_date
      select prd.term, from: "Primary Renal Diagnosis (PRD)"

      # Change something in the profile.document so we can test the document is persisting
      within ".year-dated-confirmation--ischaemic_heart_dis" do
        choose "Yes"
        select(
          "1990",
          from: "renal_profile_document_comorbidities_ischaemic_heart_dis_confirmed_on_year"
        )
      end

      within page.first(".form-actions") do
        click_on t("btn.save")
      end

      # Renal profile #show
      expect(page).to have_current_path(patient_renal_profile_path(patient))
      expect(page).to have_content(updated_esrf_date)

      # Reaching into the saved object here as it is a more reliable means of testing
      # we saved the comorbidities than reading the screen
      document = patient.reload.profile.document
      comorbidities = document.comorbidities
      expect(comorbidities.ischaemic_heart_dis).to have_attributes(
        status: "yes",
        confirmed_on_year: 1990
      )
    end

    it "pulling in the patient's current address" do
      user = login_as_clinical
      patient = create(:renal_patient, by: user)

      visit edit_patient_renal_profile_path(patient)

      within "#address_at_diagnosis" do
        fill_in "Line 1", with: "Somewhere"
        click_on "Use current address"
        expect(find_field("Line 1").value).to eq("123 Legoland")
      end
    end
  end
end
