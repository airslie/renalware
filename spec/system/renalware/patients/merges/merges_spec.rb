describe "Viewing patients merges" do
  let(:user) { login_as_clinical }
  let(:minor_patient) { create(:patient, family_name: "Minor", by: user) }
  let(:major_patient) { create(:patient, family_name: "Major", by: user) }
  let(:fallback_rule) {
    create(:patient_merge_rule, schema_name: "renalware", table_name: "*", merge: true)
  }

  describe "Listing merges" do
    it "displays a table of merges that have happened" do
      user

      create(
        :patient_merge,
        major_patient:,
        minor_patient:
      )

      visit patients_merges_path

      expect(page).to have_text("Patient Merges")
      expect(page).to have_text("Major")
      expect(page).to have_text("Minor")
      expect(page).to have_text(major_patient.family_name)
      expect(page).to have_text(minor_patient.family_name)
    end
  end

  describe "Adding a merge as a developer locally", :js do
    it "adds" do
      user
      fallback_rule
      major_patient
      minor_patient

      visit new_patients_merge_path

      pending "Fix test failure after recent changes to view"

      expect(page).to have_text("Create Patient Merge")
      fill_in "Major patient ID", with: major_patient.id
      fill_in "Minor patient ID", with: minor_patient.id
      click_button "Create Merge"

      expect(page).to have_text("Patient Merges")
      expect(page).to have_text(major_patient.family_name)
      expect(page).to have_text(minor_patient.family_name)

      click_link "Operations"
    end
  end
end
