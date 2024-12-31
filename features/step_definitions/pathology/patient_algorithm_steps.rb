Given(/^(\w+) has a recorded patient rule:$/) do |patient_name, table|
  patient = get_patient(patient_name)
  @patient_rule = create_patient_rule(
    patient,
    table.rows_hash
  )
end

Given(%r{^the current date is between the rule's start/end dates (yes|no)$}) do |within_rage|
  update_patient_rule_start_end_dates(@patient_rule, within_rage)
end

Given("a request form containing this patient rule was printed ") do
  # noop
end

Given("a request form containing this patient rule was printed {int} {word} ago") do |days_ago, _|
  if days_ago.present?
    create_request_with_patient_rules(@patty, days_ago, [@patient_rule])
  end
end

When("Clyde records a new patient rule for Patty") do
  @patient_rule_attributes = {
    lab: "Biochemistry",
    test_description: "Test for HepBsAb",
    sample_number_bottles: 1,
    frequency_type: "Always",
    start_date: Date.current,
    end_date: Date.current + 1.week
  }

  record_patient_rule(
    @patty,
    @clyde,
    @patient_rule_attributes
  )
end

When("the patient pathology algorithm is run for Patty") do
  @required_patient_observations = run_patient_algorithm(@patty, @clyde)
end

When("Clyde submits an erroneous patient rule for Patty") do
  @patient_rule_attributes = {
    lab: "Biochemistry",
    test_description: "",
    frequency_type: "Always"
  }

  record_patient_rule(
    @patty,
    @clyde,
    @patient_rule_attributes
  )
end

Then(/^it is determined the patient's observation is (required|not required)$/) do |determined|
  if determined == "required"
    expect(@required_patient_observations).to eq([@patient_rule])
  else
    expect(@required_patient_observations).to eq([])
  end
end

Then("Patty has a new patient rule") do
  expect_patient_rules_on_patient(@patty, @patient_rule_attributes)
end

Then("the patient rule is not accepted") do
  expect_patient_rule_to_be_refused(@patty)
end
