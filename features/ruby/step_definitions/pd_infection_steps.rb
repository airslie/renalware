Given(/^a patient has PD$/) do
  # pending # express the regexp above with the code you wish you had
end

Given(/^they have been diagnosed with peritonitis$/) do
  visit pd_info_patient_path(@patient)
end

When(/^the Clinician records the episode of peritonitis$/) do
  click_on "Record an Episode of Peritonitis"

  within "#peritonitis_episode_diagnosis_date_3i" do
    select '25'
  end
  within "#peritonitis_episode_diagnosis_date_2i" do
    select 'December'
  end
  within "#peritonitis_episode_diagnosis_date_1i" do
    select '2014'
  end
  
  within "#peritonitis_episode_start_treatment_date_3i" do
    select '30'
  end
  within "#peritonitis_episode_start_treatment_date_2i" do
    select 'December'
  end
  within "#peritonitis_episode_start_treatment_date_1i" do
    select '2014'
  end
  
  within "#peritonitis_episode_end_treatment_date_3i" do
    select '31'
  end
  within "#peritonitis_episode_end_treatment_date_2i" do
    select 'January'
  end
  within "#peritonitis_episode_end_treatment_date_1i" do
    select '2015'
  end

  fill_in "Episode type", :with => 3
  
  check "Catheter removed"
  
  uncheck "Line break"
  check "Exit site infection"
  check "Diarrhoea"
  check "Abdominal pain"

  fill_in "Fluid description", :with => 2
  fill_in "White cell total", :with => 1000
  fill_in "Neutro (%)", :with => 20
  fill_in "Lympho (%)", :with => 30
  fill_in "Degen (%)", :with => 25
  fill_in "Other (%)", :with => 25

  fill_in "Organism 1", :with => 1
  fill_in "Organism 2", :with => 2

  fill_in "Notes", :with => "Review in a weeks time"

  fill_in "Antibiotic 1", :with => 11
  fill_in "Antibiotic 2", :with => 12
  fill_in "Antibiotic 3", :with => 13
  fill_in "Antibiotic 4", :with => 14
  fill_in "Antibiotic 5", :with => 15

  fill_in "Route (Antibiotic 1)", :with => 1
  fill_in "Route (Antibiotic 2)", :with => 1
  fill_in "Route (Antibiotic 3)", :with => 1
  fill_in "Route (Antibiotic 4)", :with => 1
  fill_in "Route (Antibiotic 5)", :with => 2
  
  fill_in "Sensitivities", :with => "Antibiotic 1 most effective."

  click_on "Save Peritonitis Episode"

end

Then(/^the episode should be displayed on PD info page$/) do

  expect(page.has_content? "25/12/2014").to be true
  expect(page.has_content? "30/12/2014").to be true
  expect(page.has_content? "31/01/2015").to be true
  expect(page.has_content? "Catheter Removed: true").to be true
  expect(page.has_content? "Line Break: false").to be true
  expect(page.has_content? "Exit Site Infection: true").to be true
  expect(page.has_content? "Diarrhoea: true").to be true
  expect(page.has_content? "Abdominal Pain: true").to be true
  expect(page.has_content? "3").to be true
  expect(page.has_content? "1000").to be true
  expect(page.has_content? "Neutro: 20%").to be true
  expect(page.has_content? "Lympho: 30%").to be true
  expect(page.has_content? "Degen: 25%").to be true
  expect(page.has_content? "Other: 25%").to be true
  expect(page.has_content? "Antibiotic: 11").to be true
  expect(page.has_content? "Route: 1").to be true
  expect(page.has_content? "Antibiotic: 12").to be true
  expect(page.has_content? "Route: 1").to be true
  expect(page.has_content? "Antibiotic: 13").to be true
  expect(page.has_content? "Route: 1").to be true
  expect(page.has_content? "Antibiotic: 14").to be true
  expect(page.has_content? "Route: 1").to be true
  expect(page.has_content? "Antibiotic: 15").to be true 
  expect(page.has_content? "Route: 2").to be true
end

