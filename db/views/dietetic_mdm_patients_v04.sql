with latest_dietetic_clinic_visits as (
    select distinct on (patient_id)
      date,
      patient_id,
      created_by_id,
      document,
      weight,
      bmi
     from
      renalware.clinic_visits
    where type = 'Renalware::Dietetics::ClinicVisit'
    order by
      patient_id,
      date DESC,
      created_at DESC
),
 latest_dry_weights as (
    select distinct on (patient_id) *
     from renalware.clinical_dry_weights cdw
     order by patient_id, created_at desc
)
SELECT
  P.id,
  P.secure_id,
  (upper(P.family_name) || ', ' || P.given_name) AS "patient_name",
  (
    named_consultant_user.family_name || ', ' || named_consultant_user.given_name
  ) AS "consultant_name",
  P.local_patient_id AS hospital_numbers,
  P.sex,
  P.born_on,
  Mx.modality_name,
  latest_dietetic_clinic_visits.bmi AS bmi,
  (
    clinic_visit_users.family_name || ', ' || clinic_visit_users.given_name
  ) AS "dietician_name",
  convert_to_float(pathology.values -> 'POT' ->> 'result', null) as pot,
  convert_to_float(pathology.values -> 'PHOS' ->> 'result', null) as phos,
  convert_to_float(pathology.values -> 'PTH' ->> 'result', null) as pth,
  convert_to_float(pathology.values -> 'ALB' ->> 'result', null) as alb,
  convert_to_float(pathology.values -> 'URR' ->> 'result', null) as urr,
  latest_dietetic_clinic_visits.date as clinic_visit_date,
  date(
    latest_dietetic_clinic_visits.document ->> 'next_review_on'
  ) as next_review_on,
  translate(
    initcap(
      latest_dietetic_clinic_visits.document ->> 'assessment_type'
    ),
    '_',
    ' '
  ) as assessment_type,
  translate(
    initcap(
      latest_dietetic_clinic_visits.document ->> 'visit_type'
    ),
    '_',
    ' '
  ) as visit_type,
  latest_dietetic_clinic_visits.document ->> 'weight_change' || '%' as weight_change,
  latest_dietetic_clinic_visits.weight as current_weight,
  latest_dry_weights.weight as dry_weight,
  CASE
    WHEN date(
      latest_dietetic_clinic_visits.document ->> 'next_review_on'
    ) < NOW() THEN 'overdue'
    WHEN date(
      latest_dietetic_clinic_visits.document ->> 'next_review_on'
    ) < NOW() + INTERVAL '1 month' THEN 'in 1 months'
    WHEN date(
      latest_dietetic_clinic_visits.document ->> 'next_review_on'
    ) < NOW() + INTERVAL '3 month' THEN 'in 3 months'
    WHEN date(
      latest_dietetic_clinic_visits.document ->> 'next_review_on'
    ) < NOW() + INTERVAL '6 month' THEN 'in 6 months'
  END AS "outstanding_dietetic_visit",
  hospital_centre.name AS "hospital_centre",
  CASE
    WHEN pw.id > 0 THEN TRUE
    ELSE FALSE
  END AS on_worryboard
from
	latest_dietetic_clinic_visits
  INNER JOIN renalware.patients P on P.id = latest_dietetic_clinic_visits.patient_id
  LEFT OUTER JOIN latest_dry_weights on latest_dry_weights.patient_id = P.id
  INNER JOIN renalware.users clinic_visit_users ON clinic_visit_users.id = latest_dietetic_clinic_visits.created_by_id
  LEFT OUTER JOIN renalware.users named_consultant_user ON named_consultant_user.id = P.named_consultant_id
  LEFT OUTER JOIN renalware.patient_worries pw ON pw.patient_id = p.id
  LEFT OUTER JOIN renalware.pathology_current_observation_sets pathology ON pathology.patient_id = P.id
  LEFT OUTER JOIN renalware.patient_current_modalities Mx ON Mx.patient_id = P.id
  LEFT OUTER JOIN renalware.hospital_centres hospital_centre ON hospital_centre.id = P.hospital_centre_id
  -- LEFT JOIN renalware.clinical_dry_weights dry_weight ON dry_weight.patient_id = P.id
WHERE
  Mx.modality_name NOT IN ('death')
ORDER by clinic_visit_date desc;
