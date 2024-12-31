# GIVEN

Given(/^Patty has a recorded letter$/) do
  seed_simple_letter_for(@patty, user: @nathalie)
end

Given(/^Patty accepted to be CCd on all letters$/) do
  @patty.cc_on_all_letters = true
end

Given(/^Patty is the main recipient on a pending letter$/) do
  @letter = seed_simple_letter_for(@patty, user: @nathalie)
end

Given(/^Nathalie drafted a letter for Patty$/) do
  @letter = seed_simple_letter_for(@patty, user: @nathalie)
end

Given(/^Nathalie drafted a letter for Patty on behalf of Doug$/) do
  @letter = seed_simple_letter_for(@patty, user: @nathalie, author: @doug)
end

Given(/^a letter for Patty's clinical visit was drafted$/) do
  @letter = seed_clinic_visit_letter_for(@patty, user: @nathalie)
end

Given(/^Patty has completed pathology investigations relevant to the clinic letter$/) do
  seed_observations_relevant_to_clinic_letter(patient: @patty)
end

Given(/^Patty has a letter pending review authored by Doug$/) do
  @doctor = find_or_create_user(given_name: "a_doctor", role: "clinical")

  seed_simple_letter_for(@patty, user: @doctor, author: @doug)
  submit_for_review(patient: @patty, user: @doctor)
end

Given(/^Patty has a letter pending review$/) do
  @doctor = find_or_create_user(given_name: "a_doctor", role: "clinical")

  seed_simple_letter_for(@patty, user: @doctor)
  submit_for_review(patient: @patty, user: @doctor)
end

Given(/^Patty has an approved letter$/) do
  @doctor = find_or_create_user(given_name: "a_doctor", role: "clinical")

  seed_simple_letter_for(@patty, user: @doctor)
  submit_for_review(patient: @patty, user: @doctor)
  approve_letter(patient: @patty, user: @doctor)
end

Given(/^Nathalie submitted the letter for review$/) do
  submit_for_review(patient: @patty, user: @nathalie)
end

Given(/^these letters were recorded:$/) do |table|
  seed_letters(table)
end

Given(/^Sam is one of Patty's contacts$/) do
  seed_contact(patient: @patty, person: @sam)
end

Given(/^Kate is the emergency contact for Patty$/) do
  @kate = seed_person(given_name: "Kate", user: Renalware::User.first)
  seed_contact(patient: @patty, person: @kate)
end

# WHEN

When(/^Nathalie drafts a letter for Patty to "(.*?)" with "(.*?)"$/) do |rec, ccs|
  recipient = letter_recipients_map.fetch(rec)
  cc_recipients = ccs.split(",").map { |cc| letter_recipients_map.fetch(cc.strip) }

  draft_simple_letter(
    patient: @patty,
    user: @nathalie,
    created_at: Time.zone.today,
    recipient: recipient,
    ccs: cc_recipients
  )
end

When(/^Nathalie drafts a letter for Patty$/) do
  draft_simple_letter(
    patient: @patty,
    user: @nathalie,
    created_at: Time.zone.today,
    recipient: @patty
  )
end

When(/^Doug drafts a clinic visit letter for Patty$/) do
  draft_clinic_visit_letter(patient: @patty, user: @doug, created_at: Time.zone.today)
end

When(/^Nathalie updates Patty's address$/) do
  update_patient_address(patient: @patty, current_address_attributes: { street_1: "new street 1" })
end

When(/^Nathalie submits the letter for review$/) do
  submit_for_review(patient: @patty, user: @nathalie)
end

When(/^Clyde filters on his pending review letters typed by Taylor$/) do
  taylor = find_or_create_user(given_name: "Taylor", role: "clinical")
  view_letters(
    q: {
      state_eq: "pending_review",
      author_id_eq: @clyde.id,
      created_by_id_eq: taylor.id
    },
    user: @clyde
  )
end

When(/^Clyde filters on approved letters having an attachment$/) do
  view_letters(
    q: {
      state_eq: "approved",
      enclosures_present: true
    },
    user: @clyde
  )
end

Then(/^Doug can reject the letter$/) do
  reject_letter(patient: @patty, user: @doug)
end

When(/^Doug approves the letter$/) do
  approve_letter(patient: @patty, user: @doug)
end

When(/^Nathalie approves the letter$/) do
  approve_letter(patient: @patty, user: @nathalie)
end

When(/^Nathalie marks the letter as printed$/) do
  mark_letter_as_printed(patient: @patty, user: @nathalie)
end

When(/^Clyde assigns Sam as a contact for Patty$/) do
  assign_contact(patient: @patty, person: @sam, user: @clyde)
end

When(/^Clyde assigns Sam as a contact for Patty flagging them as a default CC$/) do
  assign_contact(patient: @patty, person: @sam, user: @clyde, default_cc: true)
end

When(/^Clyde assigns Sam as a contact for Patty describing them as "([^"]*)"$/) do |description_name|
  assign_contact(patient: @patty, person: @sam, user: @clyde, description_name: description_name)
end

When(/^Clyde assigns Sam as a contact for Patty describing them as Great Aunt$/) do
  assign_contact(patient: @patty, person: @sam, user: @clyde, description_name: "Great Aunt")
end

When(/^Clyde adds Diana Newton as a District Nurse contact for Patty$/) do
  assign_new_person_as_contact(
    patient: @patty, user: @clyde,
    description_name: "District Nurse",
    person_attrs: { given_name: "Diana", family_name: "Newton" }
  )
end

When(/^Doug drafts a clinical letter for Patty$/) do
  draft_clinical_letter(patient: @patty, user: @doug, created_at: Time.zone.today)
end

# THEN

Then(/^a clinical letter is drafted for Patty$/) do
  expect_clinical_letter_to_exist(patient: @patty)
end

Then(/^"(.*?)" will receive the letter$/) do |recipient|
  expect_simple_letter_to_exist(@patty, recipient: letter_recipients_map.fetch(recipient))
end

Then(/^Nathalie can revise Patty's letter$/) do
  revise_simple_letter(patient: @patty, user: @nathalie)
end

Then(/^Doug can delete Patty's letter$/) do
  delete_simple_letter(patient: @patty, user: @doug)
end

Then(/^the letter is deleted$/) do
  expect_letter_to_be_deleted
end

Then(/^Doug cannot delete Patty's letter$/) do
  expect_letter_to_be_immutable(patient: @patty, user: @doug)
end

Then(/^Doug can revise the letter$/) do
  revise_simple_letter(patient: @patty, user: @doug)
end

Then(/^Doug can revise Patty's clinic visit letter$/) do
  revise_clinic_visit_letter(patient: @patty, user: @doug)
end

Then(/^the letter is not drafted$/) do
  expect_letter_to_be_refused
end

Then(/^all "(.*?)" will also receive the letter$/) do |ccs|
  cc_recipients = ccs.split(",").map do |cc|
    letter_recipients_map.fetch(cc.strip)
  end
  expect_simple_letter_to_have_ccs(@patty, ccs: cc_recipients)
end

Then(/^Patty's pending letter is addressed to her new address$/) do
  expect_letter_to_be_addressed_to(
    letter: @letter.reload,
    address_attributes: { street_1: "new street 1" }
  )
end

Then(/^Doug can review the letter$/) do
  expect_doctor_can_review_letter(patient: @patty, doctor: @doug)
end

Then(/^a letter for Patty's clinical visit is drafted$/) do
  expect_clinic_visit_letter_to_exist(patient: @patty)
end

Then(/^the letter lists Patty's current prescriptions$/) do
  expect_letter_to_list_current_prescriptions(patient: @patty)
end

Then(/^the letter lists Patty's clinical observations$/) do
  expect_letter_to_list_clinical_observations(patient: @patty)
end

Then(/^the letter lists Patty's problems and notes$/) do
  expect_letter_to_list_problems(patient: @patty)
end

Then(/^the letter lists Patty's recent pathology results$/) do
  expect_clinical_letter_to_list_recent_pathology_results(patient: @patty)
end

Then(/^the letter lists Patty's allergies$/) do
  expect_clinical_letter_to_list_allergies(patient: @patty)
end

Then(/^the clinical letter lists Patty's current prescriptions$/) do
  expect_clinical_letter_to_list_current_prescriptions(patient: @patty)
end

Then(/^the clinical letter lists Patty's clinical observations$/) do
  expect_clinical_letter_to_list_clinical_observations(patient: @patty)
end

Then(/^the clinical letter lists Patty's problems and notes$/) do
  expect_clinical_letter_to_list_problems(patient: @patty)
end

Then(/^the clinical letter lists Patty's recent pathology results$/) do
  expect_clinical_letter_to_list_recent_pathology_results(patient: @patty)
end

Then(/^Doug can approve letter$/) do
  expect_letter_can_be_approved(patient: @patty, user: @doctor)
end

Then(/^an archived copy of the letter is available$/) do
  expect_archived_letter(patient: @patty)
end

Then(/^nobody can modify the letter$/) do
  expect_letter_to_not_be_modified(patient: @patty, user: @doctor)
end

Then(/^the letter is signed by Nathalie$/) do
  expect_letter_to_be_signed(patient: @patty, user: @nathalie)
end

Then(/^the letter is completed$/) do
  expect_letter_to_be_completed(patient: @patty, user: @nathalie)
end

Then(/^Clyde views these letters:$/) do |table|
  expect_letters_to_be(table)
end

Then(/^Sam is listed as Patty's available contacts$/) do
  expect_available_contact(patient: @patty, person: @sam)
end

Then(/^Sam is listed as Patty's default CC's$/) do
  expect_default_ccs(patient: @patty, person: @sam)
end

Then(/^Sam is listed as Patty's available contacts as a "([^"]*)"$/) do |description_name|
  expect_available_contact(patient: @patty, person: @sam, description_name: description_name)
end

Then(/^Diana is listed as Patty's available contacts as a "([^"]*)"$/) do |description_name|
  @diana = Renalware::Directory::Person.find_by(given_name: "Diana")
  expect_available_contact(patient: @patty, person: @diana, description_name: description_name)
end

Then(/^Sam is listed as Patty's available contacts as Great Aunt$/) do
  expect_available_contact(patient: @patty, person: @sam, description_name: "Great Aunt")
end
