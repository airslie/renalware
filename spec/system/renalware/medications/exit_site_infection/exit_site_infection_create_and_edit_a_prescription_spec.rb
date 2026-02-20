describe "Prescriptions - from an exit site infection", :js do
  include DrugsSpecHelper

  let(:user) { create(:user, :clinical, additional_roles: :prescriber) }
  let(:patient) { create(:pd_patient, by: user) }
  let(:drug) { create(:drug, name: "Blue Pill") }
  let(:antibiotic_drug_type) { create(:drug_type, :antibiotic) }
  let(:route) { create(:medication_route, name: "Oral") }
  let(:unit_of_measure) { create(:drug_unit_of_measure, name: "Ampoule") }

  let(:esi) { create(:exit_site_infection, patient:) }

  before do
    esi

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
    visit patient_pd_exit_site_infection_path(patient, esi)

    expect(page).to have_content "There are no prescriptions in this list."
    click_link "Add Prescription"

    # Test 'Cancel'
    click_link "Cancel"
    expect(page).to have_content "Exit Site Infection"

    # Create a prescription
    click_link "Add Prescription"
    slim_select "Blue Pill", from: "Drug", wait_for: "Search term must be"

    # Automatically pre-populates as only 1 option available
    expect(page).to have_content "Unit of measure\nAmpoule"
    expect(page).to have_content "Route\nOral"

    # Complete all required fields
    fill_in "Dose amount", with: 1
    fill_in "Other frequency", with: "abc"
    choose "GP"
    click_button "Create"

    #
    # Back on Exit Site Infection page
    expect(page).to have_content "Exit Site Infection"

    within "article", text: "Antibiotics/Routes", match: :prefer_exact do
      expect(page).to have_content("Blue Pill")
      expect(page).to have_content("1 Ampoule")
      expect(page).to have_content("abc")
      expect(page).to have_content("Oral")
      expect(page).to have_content("GP")
      expect(page).to have_content(l(Date.current))

      # Go back to Edit
      click_link "Edit"
    end

    expect(page).to have_field "Dose amount", with: "1"

    expect(page).to have_select "Drug", selected: "Blue Pill", visible: :hidden
    # TODO: detect correct readonly ame and hidden field are present
    # expect(page).to have_select "Unit of measure", selected: "Ampoule", visible: :hidden
    # expect(page).to have_select "Route", selected: "Oral", visible: :hidden

    expect(page).to have_field "Frequency", with: "abc"
    expect(page).to have_field "Prescribed on", with: l(Date.current)

    # Test 'Cancel' from edit
    click_link "Cancel"
    expect(page).to have_content "Exit Site Infection"

    # Now make a real edit
    within "article", text: "Antibiotics/Routes", match: :prefer_exact do
      click_link "Edit"
    end

    fill_in "Frequency", with: "New frequency", match: :prefer_exact
    click_button "Save"

    expect(page).to have_content "PD Summary / Exit Site Infection"
  end
end
