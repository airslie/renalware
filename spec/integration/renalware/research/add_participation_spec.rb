# frozen_string_literal: true

require "rails_helper"

describe "Add a patient to a study (creating a participation)", type: :system, js: true do
  include AjaxHelpers

  it "Adding a patient to a research study" do
    user = login_as_admin
    patient = create(:patient, family_name: "XXX", given_name: "Jon", by: user)
    study = create_study(by: user)
    visit research_study_participations_path(study)

    click_on "Add"

    expect(page).to have_current_path(new_research_study_participation_path(study))
    select2(patient.to_s(:long), css: "#patient-select2", search: true)

    fill_in "Joined on", with: "2019-01-01"
    click_on "Save"

    expect(page).to have_current_path(research_study_participations_path(study))
    expect(page).to have_content(patient.to_s)
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
