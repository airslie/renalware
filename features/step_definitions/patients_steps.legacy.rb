Given(/^I am on the patients list$/) do
  visit patients_path
end

Given(/^some patients who need renal treatment$/) do
  @patient_1 = FactoryBot.create(
    :patient,
    nhs_number: FactoryBot.generate(:nhs_number),
    local_patient_id: FactoryBot.generate(:local_patient_id),
    family_name: "RABBIT",
    given_name: "Roger",
    born_on: "01/01/1947",
    paediatric_patient_indicator: "1",
    sex: "M",
    ethnicity_id: Renalware::Patients::Ethnicity.first.id,
    hospital_centre_code: "888"
  )

  @patient_2 = FactoryBot.create(
    :patient,
    nhs_number: FactoryBot.generate(:nhs_number),
    local_patient_id: FactoryBot.generate(:local_patient_id),
    family_name: "DAY",
    given_name: "Doris",
    born_on: "24/06/1970",
    paediatric_patient_indicator: "1",
    sex: "F",
    ethnicity_id: Renalware::Patients::Ethnicity.second.id,
    hospital_centre_code: "888"
  )

  @patient_3 = FactoryBot.create(
    :patient,
    nhs_number: FactoryBot.generate(:nhs_number),
    local_patient_id: FactoryBot.generate(:local_patient_id),
    family_name: "CASPER",
    given_name: "Ghost",
    born_on: "28/02/1930",
    paediatric_patient_indicator: "1",
    sex: "M",
    ethnicity_id: Renalware::Patients::Ethnicity.first.id,
    hospital_centre_code: "999"
  )
end

Given(/^they are on a patient's clinical summary$/) do
  visit patient_clinical_summary_path(@patient_1)
end
