RSpec.describe "Add a patient to a study (creating a participation)", :js do
  context "when the user is an investigator in the study", :js do
    it "they can add patient to a research study" do
      user = login_as_clinical
      patient = create(:patient, family_name: "XXX", given_name: "Jon", by: user)
      study = create_study(by: user)
      create(
        :research_investigatorship,
        user:,
        study:,
        by: user,
        started_on: "2018-01-01"
      )
      visit research.study_participations_path(study)

      click_on "Add"

      expect(page).to have_current_path(research.new_study_participation_path(study))
      slim_select(patient.to_s(:long), from: "Patient", wait_for: "Enter at least 3 characters")

      fill_in "Joined on", with: "2019-01-01"
      fill_in "Reference within study", with: "123xx"
      click_on "Create"

      expect(page).to have_current_path(research.study_participations_path(study))
      expect(page).to have_text(patient.to_s)
      expect(page).to have_text("123xx")
    end
  end

  context "when the user is not an investigator in the study" do
    it "they cannot see the Add option" do
      user = login_as_clinical
      study = create_study(by: user)

      visit research.study_participations_path(study)

      expect(page).to have_no_css "a.add-participation"
    end
  end

  def create_study(by:)
    create(
      :research_study,
      code: "Study1",
      description: "Study 1",
      leader: "Jack Jones",
      by:
    )
  end
end
