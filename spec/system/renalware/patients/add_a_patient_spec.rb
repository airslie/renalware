describe "A user adds a patient" do
  describe "add patient flow" do
    include ConfigHelper

    before do
      configure_patient_hospital_identifiers
      allow(Renalware.config)
        .to receive(:disable_inputs_controlled_by_demographics_feed)
        .and_return(false)
    end

    it "adds a patient successfully" do
      login_as_clinical
      visit patients_path

      within ".page-actions" do
        click_link "Add"
      end

      expect(page).to have_field "Hospital centre", with: ""

      # Test for validation errors
      click_button "Create", match: :first

      expect(page).to have_text("Family name can't be blank")
      expect(page).to have_text("Given name can't be blank")
      expect(page).to have_text("Date of Birth can't be blank")
      expect(page).to have_text("Date of Birth is not a valid date")
      expect(page).to have_text("Sex is required")
      expect(page).to have_text("The patient must have at least one of these numbers: " \
                                "HOSP1, HOSP2, HOSP3, HOSP4, HOSP5, Other Hospital Number")

      fill_in "HOSP1 No", with: "12345"
      fill_in "Family name", with: "FamilyName"
      fill_in "Given name", with: "GivenName"
      fill_in "DoB", with: "2022-12-09"
      select "Not Specified", from: "Sex"
      select "Dover", from: "Hospital centre"

      # The save successfully, and go to the patient demographics page
      click_button "Create", match: :first

      expect(page).to have_text("Last Name:FamilyName")
      expect(page).to have_text("First Name:GivenName")
      expect(page).to have_text("Sex:NS")
      expect(page).to have_text("Date of Birth:09-Dec-2022")
      expect(page).to have_text("HOSP1 No:12345")
      expect(page).to have_text("Hospital centre:Dover Hospital")
    end
  end
end
