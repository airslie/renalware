describe "Managing HD Stations for a Hospital Unit" do
  before do
    create(:hd_station_location, name: "Side room")
  end

  def create_station(name, unit, by)
    create(:hd_station, name: name, hospital_unit_id: unit.id, by: by)
  end

  it "Listing existing stations" do
    user = login_as_clinical
    unit = create(:hospital_unit, unit_code: "UnitCode")
    create_station("Station-1", unit, user)
    create_station("Station-2", unit, user)

    visit hd_unit_stations_path(unit)

    expect(page).to have_content("UnitCode")
    expect(page).to have_content("Station-1")
    expect(page).to have_content("Station-2")
  end

  it "Adding a station" do
    login_as_admin
    unit = create(:hospital_unit, unit_code: "UnitCode")

    visit hd_unit_stations_path(unit)
    within(".page-actions") do
      click_on I18n.t("btn.add")
    end

    fill_in "Name", with: "Station-X"
    select "Side room", from: "Location"
    click_on t("btn.create")

    expect(page).to have_current_path(hd_unit_stations_path(unit))
    expect(page).to have_content("Station-X")
    expect(page).to have_content("Side room")
  end

  it "Editing a station" do
    user = login_as_admin
    unit = create(:hospital_unit, unit_code: "UnitCode")
    station = create_station("Station-1", unit, user)

    visit hd_unit_stations_path(unit)
    within("#hd-station-#{station.id}") do
      click_on t("btn.edit")
    end

    fill_in "Name", with: "Station-XX"
    click_on t("btn.save")

    expect(page).to have_current_path(hd_unit_stations_path(unit))
    expect(page).to have_content("Station-XX")
  end
end
