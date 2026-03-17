describe "Death location management" do
  it "enables me to list locations" do
    login_as_super_admin

    locations = [
      create(:death_location, :hospice),
      create(:death_location, :hospital)
    ]

    visit deaths_locations_path

    expect(page).to have_content("Death Locations")
    locations.each do |location|
      expect(page).to have_content(location.name)
    end
  end

  it "enables me to add a location" do
    hospice = create(:ukrdc_assessment_outcome, :hospice)
    login_as_super_admin

    visit deaths_locations_path

    within(".page-heading") do
      click_on "Add"
    end

    fill_in "Name", with: "New Location"
    select "Hospice", from: "Renal Registry Outcome Code"
    click_on "Create"

    expect(Renalware::Deaths::Location.count).to eq(1)
    expect(Renalware::Deaths::Location.first).to have_attributes(
      name: "New Location",
      ukrdc_assessment_outcome_code: hospice.code
    )
  end

  it "enables me to edit a location" do
    login_as_super_admin

    location = create(:death_location, :home)
    hospice = create(:ukrdc_assessment_outcome, :hospice)

    visit deaths_locations_path

    within("#death-locations tbody") do
      click_on "Edit"
    end

    fill_in "Name", with: "Home1"
    select "Hospice", from: "Renal Registry Outcome Code"
    click_on "Save"

    expect(location.reload).to have_attributes(
      name: "Home1",
      ukrdc_assessment_outcome_code: hospice.code
    )
  end

  it "enables me to soft delete a location" do
    login_as_super_admin

    location = create(:death_location, :home)

    visit deaths_locations_path

    within("#death-locations tbody") do
      click_on "Delete"
    end

    expect(location.reload.deleted_at).not_to be_nil

    visit deaths_locations_path

    within("#death-locations tbody") do
      expect(page).to have_no_content("Delete")
    end
  end
end
