json.id patient.id
json.secure_id patient.secure_id
json.nhs_number patient.nhs_number
json.local_patient_id patient.local_patient_id
json.local_patient_id_2 patient.local_patient_id_2
json.local_patient_id_3 patient.local_patient_id_3
json.local_patient_id_4 patient.local_patient_id_4
json.local_patient_id_5 patient.local_patient_id_5
json.title patient.title
json.given_name patient.given_name
json.family_name patient.family_name
json.born_on patient.born_on&.to_s
json.died_on patient.died_on&.to_s
json.sex patient.sex&.code
json.ethnicity patient.ethnicity&.name
json.current_address do
  json.street_1 patient.current_address&.street_1
  json.street_2 patient.current_address&.street_2
  json.street_3 patient.current_address&.street_3
  json.town patient.current_address&.town
  json.county patient.current_address&.county
  json.region patient.current_address&.region
  json.postcode patient.current_address&.postcode
  json.country patient.current_address&.country&.name
  json.telephone patient.current_address&.telephone
  json.email patient.current_address&.email
end
json.prescriptions_url api_v1_patient_prescriptions_path(patient_id: patient)
json.hd_profile_url api_v1_patient_hd_current_profile_path(patient_id: patient)
# TODO: HD Profile link to have at least site and schedule
