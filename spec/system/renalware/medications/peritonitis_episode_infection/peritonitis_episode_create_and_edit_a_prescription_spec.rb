describe "Prescriptions from a peritonitis episode, matches exit site infection 1-to-1", :js do
  include DrugsSpecHelper

  let(:user) { create(:user, :clinical, additional_roles: :prescriber) }
  let(:patient) { create(:pd_patient, by: user) }
  let(:drug) { create(:drug, name: "Blue Pill") }
  let(:antibiotic_drug_type) { create(:drug_type, :antibiotic) }
  let(:route) { create(:medication_route, name: "Oral") }
  let(:unit_of_measure) { create(:drug_unit_of_measure, name: "Ampoule") }

  let(:episode) { create(:peritonitis_episode, patient:) }

  before do
    episode

    drug.drug_types << antibiotic_drug_type

    create(
      :drug_vmp_classification,
      unit_of_measure:,
      route:,
      drug:
    )

    login_as user
    refresh_prescribable_drugs_materialized_view
  end

  it "allows to create, edit and terminate a drug" do
    visit patient_pd_peritonitis_episode_path(patient, episode)

    expect(page).to have_text "There are no prescriptions in this list."
    click_link "Add Prescription"

    # Test 'Cancel'
    click_link "Cancel"
    expect(page).to have_text "Exit Site Infection"

    # Create a prescription
    click_link "Add Prescription"
    slim_select "Blue Pill", from: "Drug", wait_for: "Search term must be"

    # Automatically pre-populates as only 1 option available
    expect(page).to have_text "Unit of measure\nAmpoule"
    expect(page).to have_text "Route\nOral"

    # Complete all required fields
    fill_in "Dose amount", with: 1
    fill_in "Other frequency", with: "abc"
    choose "GP"
    click_button "Create"

    #
    # Back on Exit Site Infection page
    expect(page).to have_text "Exit Site Infection"

    within "article", text: "Antibiotics/Routes", match: :prefer_exact do
      expect(page).to have_text("Blue Pill")
      expect(page).to have_text("1 Ampoule")
      expect(page).to have_text("abc")
      expect(page).to have_text("Oral")
      expect(page).to have_text("GP")
      expect(page).to have_text(l(Date.current))

      # Go back to Edit
      click_link "Edit"
    end

    expect(page).to have_field "Dose amount", with: "1"

    expect(page).to have_select "Drug", selected: "Blue Pill", visible: :hidden
    # expect(page).to have_select "Unit of measure", selected: "Ampoule", visible: :hidden
    # expect(page).to have_select "Route", selected: "Oral", visible: :hidden

    expect(page).to have_field "Frequency", with: "abc"
    expect(page).to have_field "Prescribed on", with: l(Date.current)

    # Test 'Cancel' from edit
    click_link "Cancel"
    expect(page).to have_text "Exit Site Infection"
  end
end
