SELECT
patients.id as patient_id,
(SELECT COUNT(*) FROM "events" WHERE "events"."patient_id" = patients.id and "events"."deleted_at" is null) as events_count,
(SELECT COUNT(*) FROM "clinic_visits" WHERE "clinic_visits"."patient_id" = patients.id) as clinic_visits_count,
(SELECT COUNT(*) FROM "letter_letters" WHERE "letter_letters"."patient_id" = patients.id) as letters_count,
(SELECT COUNT(*) FROM "modality_modalities" WHERE "modality_modalities"."patient_id" = patients.id) as modalities_count,
(SELECT COUNT(*) FROM "problem_problems" WHERE "problem_problems"."deleted_at" IS NULL AND "problem_problems"."patient_id" = patients.id) as problems_count,
(SELECT COUNT(*) FROM "pathology_observation_requests" WHERE "pathology_observation_requests"."patient_id" = patients.id) as observation_requests_count,
(SELECT COUNT(*) FROM "medication_prescriptions" P
  full outer join "medication_prescription_terminations" PT on PT.prescription_id = P.id
  WHERE P."patient_id" = patients.id
  AND (PT."terminated_on" IS NULL OR PT."terminated_on" > CURRENT_TIMESTAMP)) as prescriptions_count,
(SELECT COUNT(*) FROM "letter_contacts" WHERE "letter_contacts"."patient_id" = patients.id) as contacts_count,
(SELECT COUNT(*) FROM "transplant_recipient_operations" WHERE "transplant_recipient_operations"."patient_id" = patients.id) as recipient_operations_count,
(SELECT COUNT(*) FROM "admission_admissions" WHERE "admission_admissions"."patient_id" = patients.id) as admissions_count,
(SELECT COUNT(*) FROM "patient_attachments" WHERE "patient_attachments"."patient_id" = patients.id and "patient_attachments"."deleted_at" is null) as attachments_count
FROM patients
