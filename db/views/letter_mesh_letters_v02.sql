select
  ll.id,
  ll.approved_at,
  ll.completed_at,
  ll.gp_send_status,
  ll."type" as letter_type,
  p.family_name || ', ' || p.given_name as patient_name,
  p.secure_id as patient_secure_id,
  p.nhs_number as patient_nhs_number,
  practice.code as patient_practice_ods_code,
  lmt.sent_to_practice_ods_code,
  coalesce(practice.code, '') != coalesce(lmt.sent_to_practice_ods_code, '') as ods_code_mismatch,
  author.id as author_id,
  author.family_name || ', ' || author.given_name as author_name,
  typist.id as typist_id,
  typist.family_name || ', ' || typist.given_name as typist_name,
  lmt.id as transmission_id,
  send_operation.mesh_response_error_code as send_operation_mesh_response_error_code,
  send_operation.mesh_response_error_description as send_operation_mesh_response_error_description,
  bus_download_operation.itk3_operation_outcome_code bus_download_operation_itk3_operation_outcome_code,
  bus_download_operation.itk3_operation_outcome_description as bus_download_operation_itk3_operation_outcome_description,
  inf_download_operation.itk3_operation_outcome_code as inf_download_operation_itk3_operation_outcome_code,
  inf_download_operation.itk3_operation_outcome_description as inf_download_operation_itk3_operation_outcome_description
from letter_mesh_transmissions lmt
inner join letter_letters ll on ll.id = lmt.letter_id
inner join patients p on p.id = ll.patient_id
inner join users author on author.id = ll.author_id
inner join users typist on typist.id = ll.created_by_id
left outer join patient_practices practice on practice.id = p.practice_id
left JOIN LATERAL (
  select * from letter_mesh_operations lmo where lmo.action = 'send_message'
) send_operation on send_operation.transmission_id = lmt.id
left JOIN LATERAL (
  select * from letter_mesh_operations lmo where lmo.itk3_response_type = 'inf'
) inf_download_operation on inf_download_operation.transmission_id = lmt.id
left JOIN LATERAL (
  select * from letter_mesh_operations lmo where lmo.itk3_response_type = 'bus'
) bus_download_operation on bus_download_operation.transmission_id = lmt.id ;
