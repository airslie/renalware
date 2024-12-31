Given("the patient is cc'ed on letters") do
  (@patty || @patient_1).update_columns(cc_on_all_letters: true, cc_decision_on: "01-01-2013")
end

When("I select death modality") do
  within ".patient-content" do
    within "#modality-description-select" do
      select "Death"
      # There maybe an alert if changing from another to modality to this Death
      browser = page.driver.browser
      browser.switch_to.alert.accept if browser.respond_to?(:switch_to)
      wait_for_ajax
    end

    fill_in "Started on", with: l(Time.zone.today)
    select "Change in modality", from: "Type of Change"
    click_on t("btn.create")
  end
end

Then("I should see the patient's current modality set as death with start date") do
  visit patient_modalities_path(@patty || @patient_1)

  expect(page).to have_content("Death")
  expect(page).to have_content(l(Time.zone.today))
end

Then("I should see the date of death and causes of death in the patient's clinical profile") do
  visit patient_clinical_profile_path(@patty || @patient_1)

  expect(page).to have_content(l(Time.zone.today))
  expect(page).to have_content("Dementia")
  expect(page).to have_content("Cachexia")
end

Then("I should see the patient on the death list") do
  visit patient_deaths_path
  within("#patients-deceased") do
    if @patty || @patient_1 # prevent nil
      expect(page).to have_content((@patty || @patient_1).nhs_number_formatted)
    end
    expect(page).to have_content("M")
  end
end

When("I complete the cause of death form") do
  within ".edit_patient" do
    fill_in "Date of Death", with: l(Time.zone.today)

    select "Dementia", from: "Cause of Death (1)"
    select "Cachexia", from: "Cause of Death (2)"

    fill_in "Notes", with: "Heart stopped"

    click_on t("btn.save")
  end
end

Then("the patient should not be cc'ed on future letters") do
  @patient_1.reload
  expect(@patient_1.cc_on_all_letters).to be_falsey
  expect(@patient_1.cc_decision_on).to eq(Time.zone.today)
end
