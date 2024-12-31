#
# New steps
#
Given(/^Patty has no PD regimes$/) do
  @patty.pd_regimes.destroy_all
end

Given(/^Patty has the PD modality$/) do
  modality_description = Renalware::Modalities::Description.find_by(
    type: "Renalware::PD::ModalityDescription"
  )
  seed_modality_for(patient: @patty,
                    modality_description: modality_description,
                    user: @clyde)
end

When(/^Clyde adds a CAPD regime$/) do
  @capd_regime = record_capd_regime_for(patient: @patty, user: @clyde)
end

When(/^Clyde creates the following APD Regime for Patty$/) do |table|
  @regime = build_apd_regime_for(patient: @patty, user: @clyde, data: table.rows)
end

When(/^adds the following bags$/) do |table|
  add_bags_to_regime(regime: @regime, user: @clyde, data: table.hashes)
end

Then(/^the CAPD becomes the current one$/) do
  regime_for_patient_is_current(patient: @patty, regime: @capd_regime)
end

Then(/^the calculated regime volumes are$/) do |table|
  expect_calculated_regime_volumes_to_be(data: table.rows, regime: @regime)
end

Given(/^Patty has an existing CAPD regime$/) do
  @regime1 = record_capd_regime_for(patient: @patty, user: @clyde)
end

When(/^Clyde create a new CAPD regime$/) do
  @regime2 = record_capd_regime_for(patient: @patty, user: @clyde)
end

When(/^the new CAPD regime is current$/) do
  regime_for_patient_is_current(patient: @patty, regime: @regime2)
end

Then(/^Clyde cannot edit the old regime$/) do
  regime_is_immutable(@regime1)
end

Given(/^a patient has PD$/) do
  description = Renalware::PD::ModalityDescription.first!
  FactoryBot.create(:modality, patient: @patient_1, description: description)

  visit patient_pd_dashboard_path(@patient_1)
end

Given(/^I choose to record a new CAPD regime$/) do
  within ".page-actions" do
    click_on t("btn.add")
    click_on "CAPD Regime"
  end
end

Given(/^I choose to record a new APD regime$/) do
  within ".page-actions" do
    click_on t("btn.add")
    click_on "APD Regime"
  end
end

Given(/^a patient has existing CAPD regimes$/) do
  bag_type = Renalware::PD::BagType.find_by!(
    manufacturer: "Baxter", description: "Nutrineal PD4 (Blue)"
  )

  @capd_regime_1 = FactoryBot.create(
    :capd_regime,
    patient: @patient_1,
    start_date: "05-03-2015",
    end_date: "25-04-2015",
    treatment: "CAPD 4 exchanges per day",
    amino_acid_volume: 41,
    icodextrin_volume: 51,
    add_hd: false,
    bags_attributes: [
      bag_type: bag_type,
      volume: 1000,
      sunday: true,
      monday: true,
      tuesday: true,
      wednesday: true,
      thursday: true,
      friday: true,
      saturday: true
    ]
  )

  bag_type = Renalware::PD::BagType.find_by!(
    manufacturer: "Baxter", description: "Extraneal (Icodextrin 7.5%) (Purple)"
  )
  @capd_regime_2 = FactoryBot.create(
    :capd_regime,
    patient: @patient_1,
    start_date: "02-04-2015",
    end_date: "21-05-2015",
    treatment: "CAPD 5 exchanges per day",
    amino_acid_volume: 42,
    icodextrin_volume: 52,
    add_hd: false,
    bags_attributes: [
      bag_type: bag_type,
      volume: 1000,
      sunday: true,
      monday: true,
      tuesday: false,
      wednesday: true,
      thursday: true,
      friday: true,
      saturday: true
    ]
  )
end

Given(/^a patient has existing APD regimes$/) do
  bag_type = Renalware::PD::BagType.find_by!(
    manufacturer: "Baxter", description: "Nutrineal PD4 (Blue)"
  )

  @apd_regime_1 = FactoryBot.create(
    :apd_regime,
    patient: @patient_1,
    start_date: "17-06-2015",
    end_date: "21-07-2015",
    treatment: "APD Dry Day",
    amino_acid_volume: 46,
    icodextrin_volume: 56,
    add_hd: false,
    last_fill_volume: 630,
    additional_manual_exchange_volume: 1000,
    tidal_indicator: true,
    tidal_percentage: 60,
    no_cycles_per_apd: 3,
    overnight_volume: 7600,
    apd_machine_pac: "123-4567-890",
    bags_attributes: [
      bag_type: bag_type,
      volume: 1000,
      sunday: true,
      monday: true,
      tuesday: true,
      wednesday: true,
      thursday: true,
      friday: true,
      saturday: true
    ]
  )

  bag_type = Renalware::PD::BagType.find_by!(
    manufacturer: "Baxter", description: "Extraneal (Icodextrin 7.5%) (Purple)"
  )

  @apd_regime_2 = FactoryBot.create(
    :apd_regime,
    patient: @patient_1,
    start_date: "20-03-2015",
    end_date: "28-05-2015",
    treatment: "APD Wet Day",
    amino_acid_volume: 47,
    icodextrin_volume: 57,
    add_hd: true,
    last_fill_volume: 535,
    additional_manual_exchange_volume: 1000,
    tidal_indicator: false,
    tidal_percentage: nil,
    no_cycles_per_apd: 4,
    overnight_volume: 7800,
    apd_machine_pac: "123-4567-890",
    bags_attributes: [
      bag_type: bag_type,
      volume: 2000,
      sunday: true,
      monday: false,
      tuesday: true,
      wednesday: true,
      thursday: true,
      friday: false,
      saturday: true
    ]
  )
end

When(/^I complete the form for a CAPD regime$/) do
  fill_in "Start date", with: "02/04/2015"
  fill_in "End date", with: "01/06/2015"

  select "1 week", from: "Delivery interval"
  select "Baxter", from: "System"

  select("CAPD 4 exchanges per day", from: "Treatment")

  check "On additional HD"

  find("a.add-bag").click

  select("Baxter Nutrineal PD4 (Blue)", from: "* Bag type")

  select("2500", from: "* Volume (ml)")

  uncheck "Tue"
  uncheck "Sat"

  submit_form
end

When(/^I complete the form for a APD regime$/) do
  fill_in "Start date", with: "15/05/2015"
  fill_in "End date", with: "16/07/2015"
  select "2 weeks", from: "Delivery interval"

  select("APD Wet Day", from: "Treatment")

  find("a.add-bag").click

  select("Baxter Nutrineal PD4 (Blue)", from: "Bag type")
  select("5000", from: "* Volume (ml)")

  # TODO: Unable tp get the click behaviour on a.deselect-bag-days (to deselect
  # all days) to work here. Its a capybara issue and not worth the time resolving at this point
  # expect(page).to have_checked_field("Monday")
  # find("a.deselect-bag-days").click
  # page.should have_content # to help js finish
  # expect(page).to_not have_checked_field("Monday")

  # uncheck "Tue"
  # uncheck "Wed"
  # uncheck "Sat"
  # uncheck "Fri"

  # choose("Additional manual exchange")

  # APD specific fields
  # This has changed - last fill is no longer on the regime but
  # on a bag with role 'last fill' - may need to add another bag as last_fill here?
  # fill_in "Last Fill (ml)", with: 520

  check "Has tidal?"

  select "75", from: "Tidal (%)"

  fill_in "Dwell time", with: "100"
  select "7:30", from: "Therapy time"

  fill_in "Cycles per session", with: 3

  # fill_in "Overnight PD vol on APD", with: 3100
  fill_in "Fill volume (ml)", with: "1500"
  fill_in "Add'l man exchange vol (ml)", with: "1000"

  fill_in "Machine PAC", with: "123-4567-890"

  submit_form
end

When(/^I choose to edit and update the form for a CAPD regime$/) do
  visit patient_pd_dashboard_path(@patient_1)

  within("table.capd-regimes tbody tr:first-child") do
    click_link("Update")
  end

  fill_in "End date", with: "03/05/2015"

  submit_form

  expect(page).to have_current_path(patient_pd_dashboard_path(@patient_1))
end

When(/^I choose to edit and update the form for a APD regime$/) do
  visit patient_pd_dashboard_path(@patient_1)

  within("table.apd-regimes tbody tr:first-child") do
    click_link("Update")
  end

  select "Fresenius Sleep Safe", from: "System"
  fill_in "End date", with: "30/08/2015"

  # choose "Additional manual exchange"

  submit_form
end

When(/^I choose to view a CAPD regime$/) do
  visit patient_pd_dashboard_path(@patient_1)

  within("table.capd-regimes tbody tr:nth-child(1)") do
    click_link("View")
  end
end

When(/^I choose to view a APD regime$/) do
  visit patient_pd_dashboard_path(@patient_1)

  within("table.apd-regimes tbody tr:nth-child(1)") do
    click_link("View")
  end
end

Then(/^I should see the new CAPD regime on the PD dashboard$/) do
  within("table.capd-regimes tbody tr:first-child") do
    expect(page).to have_content(l(Date.parse("02-04-2015")))
    expect(page).to have_content(l(Date.parse("01-06-2015")))
    expect(page).to have_content("CAPD 4 exchanges per day")
  end

  # average daily glucose
  within("table.capd-regimes tbody tr:first-child td:nth-child(5)") do
    expect(page).to have_content("0")
  end

  within("table.capd-regimes tbody tr:first-child td:nth-child(6)") do
    expect(page).to have_content("0")
  end

  within("table.capd-regimes tbody tr:first-child td:nth-child(7)") do
    expect(page).to have_content("0")
  end
end

Then(/^I should see the new APD regime on the PD dashboard$/) do
  within("table.apd-regimes tbody tr:first-child") do
    expect(page).to have_content(l(Date.parse("15-05-2015")))
    expect(page).to have_content(l(Date.parse("16-07-2015")))
    expect(page).to have_content("APD Wet Day")
  end

  # average daily glucose
  within("table.apd-regimes tbody tr:first-child td:nth-child(5)") do
    expect(page).to have_content("0")
  end

  within("table.apd-regimes tbody tr:first-child td:nth-child(6)") do
    expect(page).to have_content("0")
  end

  within("table.apd-regimes tbody tr:first-child td:nth-child(7)") do
    expect(page).to have_content("0")
  end
end

Then(/^the new CAPD regime should be current$/) do
  within(".current-regime") do
    expect(page).to have_content(l(Date.parse("02-04-2015")))
    expect(page).to have_content(l(Date.parse("01-06-2015")))
    expect(page).to have_content("CAPD 4 exchanges per day")
    expect(page).to have_content("On additional HD?")
    expect(page).to have_content("Yes")
  end
end

Then(/^the new APD regime should be current$/) do
  within(".current-regime") do
    expect(page).to have_content(l(Date.parse("15-05-2015")))
    expect(page).to have_content(l(Date.parse("16-07-2015")))
    expect(page).to have_content("APD Wet")
    expect(page).to have_content("On additional HD?")
    expect(page).to have_content("No")
    expect(page).to have_content("Add'l manual exchange?:\nNo")

    expect(page).to have_content("Low strength\n0 ml")
    expect(page).to have_content("Med. strength\n0 ml")
    expect(page).to have_content("High strength\n0 ml")

    # pd regime bags
    expect(page).to have_content("Nutrineal PD4 (Blue)")
    #  Volume: 4000ml, No. per week: 3, Days: Sun, Mon, Thu"
    # )

    # expect(page).to have_content("Last Fill: 520")
    expect(page).to have_content("Therapy time:\n7:30")
    expect(page).to have_content("Dwell time:\n100")
    expect(page).to have_content("Cycles per session:\n3")
    expect(page).to have_content("123-4567-890")
  end
end

Then(/^I should see the updated CAPD regime on the PD dashboard$/) do
  within("table.capd-regimes tbody tr:first-child") do
    expect(page).to have_content(l(Date.parse("03-05-2015")))
  end
end

Then(/^I should see the updated APD regime on the PD dashboard$/) do
  within("table.apd-regimes tbody tr:first-child") do
    expect(page).to have_content(l(Date.parse("30-08-2015")))
  end
end

Then(/^I should see the chosen CAPD regime details$/) do
  expect(page).to have_content(l(Date.parse("02-04-2015")))
  expect(page).to have_content(l(Date.parse("21-May-2015")))
  expect(page).to have_content("Treatment:")
  expect(page).to have_content("CAPD 5 exchanges per day")
  expect(page).to have_content("On additional HD?")
  expect(page).to have_content("No")
end

Then(/^I should see the chosen APD regime details$/) do
  expect(page).to have_content("Start")
  expect(page).to have_content(l(Date.parse("20-03-2015")))
  expect(page).to have_content("End")
  expect(page).to have_content(l(Date.parse("28-05-2015")))
  expect(page).to have_content("Treatment")
  expect(page).to have_content("APD Wet Day")
  expect(page).to have_content("On additional HD?")
  expect(page).to have_content("Yes")
  expect(page).to have_content("Add'l manual exchange?")
  expect(page).to have_content("Yes")
  expect(page).to have_content("Tidal")
  expect(page).to have_content("No")
  expect(page).to have_content("Cycles per session")
  expect(page).to have_content("4")
  expect(page).to have_content("Overnight APD volume")
  expect(page).to have_content("Machine PAC")
  expect(page).to have_content("123-4567-890")
end
