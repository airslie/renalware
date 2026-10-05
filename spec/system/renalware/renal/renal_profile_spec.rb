describe "Renal Profile", :js do
  it "sets legacy comorbidities to No and smoking to Non without changing diagnosis years" do
    allow(Renalware.config).to receive(:use_rolling_comorbidities).and_return(false)
    user = login_as_clinical
    patient = create(:renal_patient, by: user)
    patient.create_profile!

    visit patient_renal_profile_path(patient)
    within ".page-actions" do
      click_on t("btn.edit")
    end
    expect(page).to have_current_path(edit_patient_renal_profile_path(patient))

    within ".year-dated-confirmation--ischaemic_heart_dis" do
      choose "Yes"
      select "1990"
    end
    find('input[type="radio"][value="current"]').choose

    click_on "Set all comorbidities to No"

    within "table.comorbidities" do
      expect(page).to have_css('input[type="radio"][value="no"]:checked', count: 15)
      expect(page).to have_css('input[type="radio"][value="non_smoker"]:checked', count: 1)
    end
    within ".year-dated-confirmation--ischaemic_heart_dis" do
      expect(page).to have_select(selected: "1990")
    end

    within page.first(".form-actions") do
      click_on t("btn.save")
    end
    expect(page).to have_current_path(patient_renal_profile_path(patient))

    comorbidities = patient.reload.profile.document.comorbidities
    expect(comorbidities.smoking.value).to eq("non_smoker")
    expect(comorbidities.ischaemic_heart_dis.confirmed_on_year).to eq(1990)
    (comorbidities.class.attributes_list - [:smoking]).each do |attribute|
      expect(comorbidities.public_send(attribute).status).to eq("no")
    end
  end

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
      expect(page).to have_text(esrf_date)

      within ".page-actions" do
        click_on t("btn.edit")
      end

      # Renal profile #edit
      expect(page).to have_current_path(edit_patient_renal_profile_path(patient))

      updated_esrf_date = "25-Mar-2016"
      fill_in "ESRF Date", with: updated_esrf_date
      slim_select prd.term, from: "Primary Renal Diagnosis (PRD)"

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
      expect(page).to have_text(updated_esrf_date)

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
      country = create(:algeria)
      patient.current_address.update!(country:, postcode: "AB1 2CD", telephone: "01234567890")
      profile = patient.create_profile!
      address = profile.create_address_at_diagnosis!(street_1: "Old address")

      visit patient_renal_profile_path(patient)
      within ".page-actions" do
        click_on t("btn.edit")
      end
      expect(page).to have_current_path(edit_patient_renal_profile_path(patient))

      within "#address_at_diagnosis" do
        fill_in "Line 1", with: "Somewhere"
        click_on "Use current address"
        expect(page).to have_field("Line 1", with: "123 Legoland")
        expect(page).to have_field("Postcode", with: "AB1 2CD")
        expect(page).to have_field("Telephone", with: "01234567890")
        expect(page).to have_select("Country", selected: country.name)

        fill_in "Line 1", with: "Changed again"
        click_on "Use current address"
        expect(page).to have_field("Line 1", with: "123 Legoland")
      end

      within page.first(".form-actions") do
        click_on t("btn.save")
      end
      expect(page).to have_current_path(patient_renal_profile_path(patient))
      expect(profile.reload.address_at_diagnosis).to have_attributes(
        id: address.id,
        street_1: "123 Legoland",
        postcode: "AB1 2CD",
        telephone: "01234567890",
        country_id: country.id
      )
      expect(patient.current_address.reload.street_1).to eq("123 Legoland")
    end
  end
end
