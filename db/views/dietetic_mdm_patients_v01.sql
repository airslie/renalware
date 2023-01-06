SELECT
  P.id,
  P.secure_id,
  (upper(P.family_name) || ', ' || P.given_name) AS "patient_name",
  (
    upper(named_consultant_user.family_name) || ', ' || named_consultant_user.given_name
  ) AS "consultant_name",
  P.local_patient_id AS hospital_numbers,
  P.sex,
  P.born_on,
  Mx.modality_name,
  most_recent_clinic_visit.bmi AS bmi,
  (
    upper(clinic_visit_users.family_name) || ', ' || clinic_visit_users.given_name
  ) AS "dietician_name",
  convert_to_float(pathology.values -> 'POT' ->> 'result', null) as pot,
  convert_to_float(pathology.values -> 'PHOS' ->> 'result', null) as phos,
  convert_to_float(pathology.values -> 'PTH' ->> 'result', null) as pth,
  convert_to_float(pathology.values -> 'ALB' ->> 'result', null) as alb,
  convert_to_float(pathology.values -> 'URR' ->> 'result', null) as urr,
  most_recent_clinic_visit.date as clinic_visit_date,
  date(
    most_recent_clinic_visit.document ->> 'next_review_on'
  ) as next_review_on,
  translate(
    initcap(
      most_recent_clinic_visit.document ->> 'assessment_type'
    ),
    '_',
    ' '
  ) as assessment_type,
  most_recent_clinic_visit.document ->> 'weight_change' || '%' as weight_change,
  most_recent_clinic_visit.weight as current_weight,
  dry_weight.weight as dry_weight,
  CASE
    WHEN date(
      most_recent_clinic_visit.document ->> 'next_review_on'
    ) < NOW() THEN 'overdue'
    WHEN date(
      most_recent_clinic_visit.document ->> 'next_review_on'
    ) < NOW() + INTERVAL '1 month' THEN 'in 1 months'
    WHEN date(
      most_recent_clinic_visit.document ->> 'next_review_on'
    ) < NOW() + INTERVAL '3 month' THEN 'in 3 months'
    WHEN date(
      most_recent_clinic_visit.document ->> 'next_review_on'
    ) < NOW() + INTERVAL '6 month' THEN 'in 6 months'
  END AS "outstanding_dietetic_visit",
  hospital_centre.name AS "hospital_centre",
  CASE
    WHEN pw.id > 0 THEN TRUE
    ELSE FALSE
  END AS on_worryboard
FROM
  renalware.patients P
  INNER JOIN lateral (
    select
      clinic_visits.date,
      clinic_visits.patient_id,
      clinic_visits.created_by_id,
      clinic_visits.document,
      clinic_visits.weight,
      clinic_visits.bmi
    from
      renalware.clinic_visits
    where
      clinic_visits.patient_id = p.id
    order by
      date DESC,
      created_at DESC
    limit
      1
  ) as most_recent_clinic_visit on true
  INNER JOIN renalware.users clinic_visit_users ON clinic_visit_users.id = most_recent_clinic_visit.created_by_id
  LEFT JOIN renalware.users named_consultant_user ON named_consultant_user.id = P.named_consultant_id
  LEFT JOIN renalware.patient_worries pw ON pw.patient_id = p.id
  LEFT OUTER JOIN renalware.pathology_current_observation_sets pathology ON pathology.patient_id = P.id
  INNER JOIN renalware.patient_current_modalities Mx ON Mx.patient_id = P.id
  INNER JOIN renalware.hospital_centres hospital_centre ON hospital_centre.id = P.hospital_centre_id
  LEFT JOIN renalware.clinical_dry_weights dry_weight ON dry_weight.patient_id = P.id
WHERE
  Mx.modality_name NOT IN ('death')
ORDER BY
  clinic_visit_date asc
