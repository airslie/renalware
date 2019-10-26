# frozen_string_literal: true

require "rails_helper"

describe "Problem notes management", type: :system, js: true do
  it "adding a problem note" do
    user = login_as_clinical
    patient = create(:patient, by: user)
    problem = create(:problem, patient: patient, by: user)

    visit patient_problem_path(patient, problem)

    expect(page).to have_content("Problem")
    click_on "Add Note"

    within "#new-note-area" do
      fill_in "Text", with: "Z123"
      click_on "Save"
    end

    within "#problem-notes" do
      expect(page).to have_css("table tbody tr", count: 1)
      expect(page).to have_content("Z123")
    end
  end

  it "editing a problem note" do
    user = login_as_clinical
    patient = create(:patient, by: user)
    problem = create(:problem, patient: patient, by: user)
    note = problem.notes.create!(description: "Z123", by: user)

    visit patient_problem_path(patient, problem)

    within "#problem-notes" do
      expect(page).to have_content(note.description)
      click_on "Edit"
      fill_in "Text", with: "ACB321"
      click_on "Save"
      expect(page).to have_content(note.description)
      expect(note.reload.description).to eq("ACB321")
    end
  end
end
