module Renalware
  describe "editing a worries", :js do
    it "editing a worry from the worryboard" do
      user = login_as_clinical
      patient = create(:patient, by: user)
      worry = patient.build_worry
      worry.save_by!(user)
      create(:worry_category, name: "Category99")

      visit worryboard_path

      within("##{dom_id(worry)}") do
        click_on "Edit"
      end

      fill_in "Optional notes", with: "new notes"
      select "Category99", from: "Worry category"
      click_on "Save"

      within("##{dom_id(worry)}") do
        expect(page).to have_content("Category99")
        page.find("a.toggler").click # toggle notes open - will be in another tbody
        expect(page).to have_content("new notes")
      end
    end

    it "editing a worry from a patient page" do
      user = login_as_clinical
      patient = create(:patient, by: user)
      worry = patient.build_worry
      worry.save_by!(user)
      category = create(:worry_category, name: "Category99")

      visit patient_path(patient)

      within(".patient-side-nav .side-nav") do
        click_on "Edit worry"
      end

      fill_in "Optional notes", with: "new notes"
      select "Category99", from: "Worry category"
      click_on "Save"

      expect(page).to have_current_path(patient_path(patient))
      patient_path(patient)

      expect(patient.worry.reload).to have_attributes(
        notes: "new notes",
        worry_category_id: category.id
      )
    end
  end
end
