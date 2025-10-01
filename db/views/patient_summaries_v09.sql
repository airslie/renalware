SELECT
  patients.id AS patient_id,
  (
    SELECT COUNT(*)
    FROM "events"
    WHERE "events"."patient_id" = patients.id
      AND "events"."deleted_at" IS NULL
  ) AS events_count,
  (
    SELECT COUNT(*)
    FROM "clinic_visits"
    WHERE "clinic_visits"."patient_id" = patients.id
  ) AS clinic_visits_count,
  (
    SELECT COUNT(*)
    FROM "letter_letters"
    WHERE "letter_letters"."patient_id" = patients.id
      AND "letter_letters"."deleted_at" IS NULL
  ) AS letters_count,
  (
    SELECT COUNT(*)
    FROM "modality_modalities"
    WHERE "modality_modalities"."patient_id" = patients.id
  ) AS modalities_count,
  (
    SELECT COUNT(*)
    FROM "problem_problems"
    WHERE "problem_problems"."deleted_at" IS NULL
      AND "problem_problems"."patient_id" = patients.id
  ) AS problems_count,
  (
    SELECT COUNT(*)
    FROM "pathology_observation_requests"
    WHERE "pathology_observation_requests"."patient_id" = patients.id
  ) AS observation_requests_count,
  (
    SELECT COUNT(*)
    FROM "medication_prescriptions" P
    FULL OUTER JOIN "medication_prescription_terminations" PT
      ON PT.prescription_id = P.id
    WHERE P."patient_id" = patients.id
      AND (PT."terminated_on" IS NULL OR PT."terminated_on" > CURRENT_TIMESTAMP)
  ) AS prescriptions_count,
  (
    SELECT COUNT(*)
    FROM "letter_contacts"
    WHERE "letter_contacts"."patient_id" = patients.id
  ) AS contacts_count,
  (
    SELECT COUNT(*)
    FROM "transplant_recipient_operations"
    WHERE "transplant_recipient_operations"."patient_id" = patients.id
  ) AS recipient_operations_count,
  (
    SELECT COUNT(*)
    FROM "admission_admissions"
    WHERE "admission_admissions"."patient_id" = patients.id
  ) AS admissions_count,
  (
    SELECT COUNT(*)
    FROM "patient_attachments"
    WHERE "patient_attachments"."patient_id" = patients.id
      AND "patient_attachments"."deleted_at" IS NULL
  ) AS attachments_count
FROM patients
