# frozen_string_literal: true

require "rails_helper"
require "test_support/ajax_helpers"

RSpec.describe "Editing an investigation", type: :feature, js: true do
  include AjaxHelpers
  include PatientsSpecHelper

  it "allows an investigation to be updated" do
    page.driver.add_headers("Referer" => root_path)
    user = login_as_clinical
    patient = create(:patient, by: user)
    set_modality(
      patient: patient,
      modality_description: create(:modality_description, :transplant),
      by: user
    )

    investigation = create(
      :investigation,
      :transplant_recipient,
      patient: patient,
      by: user)
    investigation.document.result = "initial_result"
    investigation.save!

    tx_dashboard_path = patient_transplants_recipient_dashboard_path(patient)
    edit_path = edit_patient_investigation_path(patient, investigation)

    visit tx_dashboard_path

    # On Tx Recip Dashboard, check we can see the investigation we just created
    within("article.investigations") do
      expect(page).to have_selector("tbody tr", count: 1)
      expect(page).to have_content("initial_result")
      click_on "Edit"
    end

    expect(page).to have_current_path(edit_path)

    # Edit..
    fill_in "Result", with: "edited_result"
    click_on "Save"

    # Back on Tx Recip Dashboard path..
    # TODO: there is an issue raised to implement the redirect back to the correct dashboard.
    # For now it is redirecting to /events
    # expect(page).to have_current_path(tx_dashboard_path)
    # within("article.investigations") do
    #   expect(page).to have_selector("tbody tr", count: 1)
    #   expect(page).to have_content("edited_result")
    # end
    expect(page).to have_current_path(patient_events_path(patient))
    within("table.events-table") do
      expect(page).to have_selector("tbody tr", count: 1)
      expect(page).to have_content("edited_result")
    end
  end
end
