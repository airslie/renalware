# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += %i(
  password
  administered_by_password
  witnessed_by_password
  nhs_number
  local_patient_id
  local_patient_id_2
  local_patient_id_3
  local_patient_id_4
  local_patient_id_5
  family_name
  given_name
  telephone
  email
)
