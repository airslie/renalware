# This is a simple test to be sure the patient search in the menu bar is working
describe "Searching for a patient from the menu bar search area" do
  it "finds target patients using a fuzzy search" do
    user = login_as_clinical
    create(:patient, by: user, family_name: "RABBIT", given_name: "Roger")
    create(:patient, by: user, family_name: "MOUSE", given_name: "Minnie")
    visit patients_path

    expect(page).to have_text("RABBIT, Roger")
    expect(page).to have_text("MOUSE, Minnie")

    within(".patient-search-form") do
      fill_in "patient_search_identity_match", with: "rab ro"
      find(".button").click
    end

    expect(page).to have_text("RABBIT, Roger")
    expect(page).to have_no_text("MOUSE, Minnie")

    within(".patient-search-form") do
      fill_in "patient_search_identity_match", with: "mous m"
      find(".button").click
    end

    expect(page).to have_text("MOUSE, Minnie")
    expect(page).to have_no_text("RABBIT, Roger")
  end
end
