Given("Patty has a request form generated with parameters:") do |table|
  params = table.rows_hash
  pathology_patient = Renalware::Pathology.cast_patient(@patty)

  @request_forms = generate_request_forms_for_single_patient(
    @clyde,
    clinic: params[:clinic],
    consultant: params[:consultant],
    consultant_code: params[:consultant_code],
    telephone: params[:telephone],
    template: params[:template],
    patients: [pathology_patient]
  )
end

When(/^Clyde chooses the consultant (\w+\s\w+)$/) do |user_name|
  @request_forms = update_request_form_user(user_name)
end

When("Clyde chooses the clinic {word}") do |clinic_name|
  @request_forms = update_request_form_clinic(clinic_name)
end

When("Clyde chooses the telephone number {int}") do |telephone|
  @request_forms = update_request_form_telephone(telephone)
end

When("Clyde generates the request forms for the appointments with the following parameters:") do |table|
  params = table.rows.to_h.with_indifferent_access

  @appointments = view_appointments(@clyde)
  @request_forms = generate_request_forms_for_appointments(@clyde, @appointments, params)
end

When("Clyde generates the request forms for the appointments sorted by user with the following parameters:") do |table|
  params = table.rows.to_h.with_indifferent_access

  @appointments = view_appointments(@clyde, q: { s: "user_family_name asc" })
  @request_forms = generate_request_forms_for_appointments(@clyde, @appointments, params)
end

When("Clyde generates the request form for {word} with the following parameters:") do |patient_name, table|
  params =
    table.rows.to_h
      .merge(patients: [patient_name])
      .with_indifferent_access

  @request_forms = generate_request_forms_for_single_patient(@clyde, params)
end

When("Clyde prints Patty's request form") do
  print_request_forms(@request_forms)
end

Then("Clyde sees these details at the top of {word}'s form") do |patient_name, table|
  patient = get_patient(patient_name)
  expect_patient_summary_to_match_table(@request_forms, patient, table.rows_hash)
end

Then("Clyde sees the following pathology requirements for {word}:") do |patient_name, table|
  patient = get_patient(patient_name)
  expect_pathology_form(@request_forms, patient, table.rows_hash)
end

Then("Clyde sees the requests forms for these patients:") do |table|
  patients = table.rows.map do |patient_full_name, _user_full_name|
    given_name, family_name = patient_full_name.split
    Renalware::Pathology::Patient.find_by(given_name: given_name, family_name: family_name)
  end

  expect_pathology_forms_for_patients(@request_forms, patients)
end

Then("Patty has the request recorded and printed:") do |table|
  params = table.rows_hash.with_indifferent_access
  expect_request_form_recorded_and_printed(@patty, params)
end
