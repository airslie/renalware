Given("Patty has the HD modality") do
  modality_description = Renalware::Modalities::Description.find_by(
    type: "Renalware::HD::ModalityDescription"
  )
  seed_modality_for(patient: @patty,
                    modality_description: modality_description,
                    user: Renalware::User.first)
end

Given("Patty has recorded HD preferences") do
  seed_hd_preferences_for(@patty, user: @clyde)
end

Given("Patty has a recorded HD profile") do
  seed_hd_profile_for(@patty, prescriber: Renalware::User.first)
end

Given("Patty has a recorded HD session") do
  seed_open_session_for(@patty, user: Renalware::User.first)
end

Given("Patty has an ongoing HD session") do
  seed_open_session_for(@patty, user: @nathalie)
end

Given("Patty has a recorded DNA session") do
  @session = seed_dna_session(patient: @patty,
                              user: @nathalie,
                              notes: "",
                              started_at: Time.zone.now)
end

Given("the session was created less than {int} hours ago") do |hours|
  session_age = Time.zone.now - hours.hours + 5.minutes # eg 5 hours 55 mins if hours == 6
  @session.update!(created_at: session_age)
end

Given("Patty has a recorded HD session with has not yet been signed off") do
  @session = seed_open_session_for(@patty, user: Renalware::User.first)
end

When("Nathalie deletes the session") do
  # Clear jobs as later there's an expectation on an enqueued job
  ActiveJob::Base.queue_adapter.enqueued_jobs.clear

  delete_session(@session, user: @nathalie)
end

Then("the session is removed") do
  expect_hd_session_to_not_exist(@session)
end

Then("the patient's HD profile should be deactivated") do
  profile = Renalware::HD.cast_patient(@patty.reload).hd_profile
  expect(profile).to be_nil
end

Given("Patty has a recorded dry weight entry") do
  seed_dry_weight_for(@patty, @clyde)
end

Given("These patients have these HD sessions") do |table|
  seed_hd_sessions(table)
end

Given("Patty has these sessions") do |table|
  seed_patient_hd_sessions(patient: @patty, table: table)
end

When(/^Nathalie records a DNA HD session for Patty with the notes "([^"]*)"$/) do |notes|
  create_dna_session(patient: @patty,
                     user: @nathalie,
                     notes: notes)
end

When("Clyde brings up the MDM page for Patty") do
  pending
  view_patient_mdm_page(patient: @patty, user: @clyde)
end

When("Nathalie views Patty's sessions") do
  view_patients_hd_sessions(patient: @patty, user: @nathalie)
end

When("Clyde records the HD preferences of Patty") do
  create_hd_preferences(patient: @patty, user: @clyde)
end

When("Clyde records an HD profile for Patty") do
  create_hd_profile(patient: @patty, user: @clyde, prescriber: @clyde)
end

When("Clyde submits an erroneous HD profile") do
  create_hd_profile(patient: @patty, user: @clyde, prescriber: nil)
end

When("Nathalie records the pre-session observations for Patty") do
  create_hd_session(patient: @patty, user: @nathalie, started_at: Time.zone.now)
end

When("Clyde records the dry weight for Patty") do
  create_dry_weight(patient: @patty, user: @clyde, assessed_on: Time.zone.today)
end

When("Nathalie submits an erroneous HD session") do
  create_hd_session(patient: @patty, user: @nathalie, started_at: nil)
end

When("Clyde submits an erroneous dry weight") do
  create_dry_weight(patient: @patty, user: @clyde, assessed_on: nil)
end

When("Clyde views the list of ongoing HD sessions") do
  view_ongoing_hd_sessions(user: @clyde)
end

When("Nathalie later adds post-session observations for Patty and signs off the session") do
  sign_off_hd_session_for(@patty, user: @nathalie)
end

Then("Patty has a signed-off session HD session") do
  expect_session_to_be_signed_off(patient: @patty)
end

Then("the MDM displays the following sessions") do |table|
  expect_mdm_to_include_patient_sessions(patient: @patty, table: table)
end

Then("Nathalie sees all Patty's HD sessions") do
  expect_all_patient_hd_sessions_to_be_present(patient: @patty, user: @nathalie)
end

Then("Patty has new HD preferences") do
  expect_hd_preferences_to_exist(@patty)
end

Then("Clyde can update Patty's HD preferences") do
  update_hd_preferences(patient: @patty, user: @clyde)
end

Then("Patty has a new HD profile") do
  expect_hd_profile_to_exist(@patty)
end

Then("Clyde can update Patty's HD profile") do
  update_hd_profile(patient: @patty, user: @clyde)
end

Then("the HD profile is not accepted") do
  expect_hd_profile_to_be_refused
end

Then("Patty has a new HD session") do
  expect_hd_session_to_exist(@patty)
end

Then("Nathalie can update Patty's HD session") do
  update_hd_session(patient: @patty, user: @nathalie)
end

Then("the HD session is not accepted") do
  expect_hd_session_to_be_refused
end

Then("Patty has a new dry weight") do
  expect_dry_weight_to_exist(@patty)
end

Then("the dry weight is not accepted") do
  expect_dry_weight_to_be_refused(@patty)
end

Then("Clyde sees these HD sessions") do |table|
  expect_hd_sessions_to_be(table.hashes)
end

Then("Patty has a new NDA HD session") do
  expect_dna_session_to_exist(patient: @patty)
end

When("Natalie views the protocol") do
  view_protocol(@patty)
end

Given("Patty has these recorded HD Sessions") do
  pending
end

Then(/^the protocol contains$/) do |table|
  pending
  expect_protocol_to_be(table.hashes)
end

Then("the rolling session statitics for the patient are regenerated") do
  assert_rolling_session_statitics_job_enqueued
end
