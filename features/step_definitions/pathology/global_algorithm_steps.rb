# frozen_string_literal: true

Given("the rule set contains these rules:") do |table|
  @rules = create_global_rules_from_table(table)
end

Given("the global rule sets:") do |table|
  num_columns = table.raw.first.count

  if num_columns > 2
    table.hashes.each do |params|
      create_global_rule_set(params)
    end
  else
    @rule_set = create_global_rule_set(table.rows_hash)
  end
end

Given(/^(\w+) has observed (a|an) ([A-Z0-9]+) value of (.+)$/) do |patient_name, _, code, result|
  patient = get_patient(patient_name)
  record_observations(
    patient: patient,
    observations_attributes: [
      { "code" => code, "result" => result, "observed_at" => Date.current.to_s }
    ]
  )
end

Given(/^Patty was last tested for ([A-Z0-9]+) (.*)$/) do |code, time_ago|
  if time_ago.present?
    # Setting the time here to 01:00 to allow for timezone errors in this test that need
    # addressing at some point. I think it is to do with the current_observation_set observed_at
    # not being stored with time zone information, so parsing to a Time ort Date might result
    # in the date beng the day before the results was actually observered.
    observed_at = str_to_time(time_ago).beginning_of_day + 3600
    record_observations(
      patient: @patty,
      observations_attributes: [
        { "code" => code, "result" => rand(100), "observed_at" => observed_at.to_s }
      ]
    )
  end
end

Given(/^Patty is currently prescribed Ephedrine Tablet (yes|no)$/) do |prescribed|
  if prescribed == "yes"
    drug = Renalware::Drugs::Drug.find_by(name: "Ephedrine Tablet")
    route = Renalware::Medications::MedicationRoute.find_by(name: "Oral")
    @patty.prescriptions.create!(
      drug: drug,
      medication_route: route,
      dose_amount: "20",
      dose_unit: "milligram",
      frequency: "daily",
      prescribed_on: 1.week.ago,
      provider: 0,
      treatable: @patty,
      by: Renalware::SystemUser.find
    )
  end
end

When(/^the global pathology algorithm is run for Patty in clinic (.*)$/) do |clinic_name|
  @required_request_descriptions = run_global_algorithm(@patty, @clyde, clinic_name)
end

When(/^Clyde views the list of required pathology for Patty in clinic (.*)$/) do |clinic_name|
  @required_request_descriptions = run_global_algorithm(@patty, @clyde, clinic_name)
  @required_patient_observations = run_patient_algorithm(@patty, @clyde)
end

Then(/^it is determined the observation is (required|not required)$/) do |determined|
  if determined == "required"
    expect(@required_request_descriptions).to eq(
      [@rule_set.request_description]
    )
  else
    expect(@required_request_descriptions).to eq([])
  end
end

Then("Clyde sees these request descriptions from the global algorithm") do |table|
  expect_observations_from_global(@required_request_descriptions, table)
end

Then("Clyde sees these observations from the patient algorithm") do |table|
  expect_observations_from_patient(@required_patient_observations, table.transpose)
end
