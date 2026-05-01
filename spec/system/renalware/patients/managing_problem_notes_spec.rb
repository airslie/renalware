describe "Problem notes management", :js do
  it "adding a problem note" do
    user = login_as_clinical
    patient = create(:patient, by: user)
    problem = create(:problem, patient:, by: user)

    visit patient_problem_path(patient, problem)

    expect(page).to have_text("Problem")
    click_on "Add Note"

    within "#new-note-area" do
      fill_in "Text", with: "Z123"
      click_on t("btn.create")
    end

    within "#problem-notes" do
      expect(page).to have_css("table tbody tr", count: 1)
      expect(page).to have_text("Z123")
    end
  end

  it "editing a problem note" do
    user = login_as_clinical
    patient = create(:patient, by: user)
    problem = create(:problem, patient:, by: user)
    note = problem.notes.create!(description: "Z123", by: user)

    visit patient_problem_path(patient, problem)

    within "#problem-notes" do
      expect(page).to have_text(note.description)
      click_on t("btn.edit")
      fill_in "Text", with: "ACB321"
      click_on t("btn.save")
      expect(page).to have_text("ACB321")
      expect(note.reload.description).to eq("ACB321")
    end
  end

  it "deleting a problem note" do
    user = login_as_clinical
    patient = create(:patient, by: user)
    problem = create(:problem, patient:, by: user)
    note = problem.notes.create!(description: "Z123", by: user)

    visit patient_problem_path(patient, problem)

    within "#problem-notes" do
      expect(page).to have_text(note.description)
      accept_alert do
        click_on t("btn.delete")
      end
      expect(page).to have_no_text(note.description)
    end
  end
end
