# frozen_string_literal: true

require "rails_helper"

describe "Edit a patient's participation in a study" do
  include AjaxHelpers

  context "when the user is an investogator in the study" do
    it "Updating a participation" do
      user = login_as_admin
      participation = create(:research_participation, by: user)
      create(
        :research_investigatorship,
        user: user,
        study: participation.study,
        by: user,
        started_on: "2018-01-01"
      )

      visit research_study_participations_path(participation.study)

      within ".study-participations-table" do
        click_on "Edit"
      end

      expect(page).to have_current_path(
        edit_research_study_participation_path(participation.study, participation)
      )

      # Add a left_on date
      fill_in "Left on", with: "2019-02-01"
      click_on "Save"

      expect(page).to have_current_path(research_study_participations_path(participation.study))
      expect(page).to have_content(participation.patient.to_s)
      expect(page).to have_content("01-Feb-2019")
    end
  end
end
