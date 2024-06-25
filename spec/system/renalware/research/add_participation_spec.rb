# frozen_string_literal: true

require "rails_helper"

describe "Add a patient to a study (creating a participation)" do
  include AjaxHelpers

  context "when the user is an investigator in the study", js: true do
    it "they can add patient to a research study" do
      user = login_as_clinical
      patient = create(:patient, family_name: "XXX", given_name: "Jon", by: user)
      study = create_study(by: user)
      create(
        :research_investigatorship,
        user: user,
        study: study,
        by: user,
        started_on: "2018-01-01"
      )
      visit research_study_participations_path(study)

      click_on "Add participant"

      expect(page).to have_current_path(new_research_study_participation_path(study))
      select2(patient.to_s(:long), css: "#patient-select2", search: true)

      fill_in "Joined on", with: "2019-01-01"
      fill_in "Reference within study", with: "123xx"
      click_on "Create"

      expect(page).to have_current_path(research_study_participations_path(study))
      expect(page).to have_content(patient.to_s)
      expect(page).to have_content("123xx")
    end
  end

  context "when the user is not an investigator in the study" do
    it "they cannot see the Add option" do
      user = login_as_clinical
      study = create_study(by: user)

      visit research_study_participations_path(study)

      expect(page).to have_no_css "a.add-participation"
    end
  end

  def create_study(by:)
    create(
      :research_study,
      code: "Study1",
      description: "Study 1",
      leader: "Jack Jones",
      by: by
    )
  end
end
