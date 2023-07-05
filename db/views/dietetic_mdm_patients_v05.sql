WITH latest_dietetic_clinic_visits AS (
         SELECT DISTINCT ON (clinic_visits.patient_id) clinic_visits.date,
            clinic_visits.patient_id,
            clinic_visits.created_by_id,
            clinic_visits.document,
            clinic_visits.weight,
            clinic_visits.bmi
           FROM renalware.clinic_visits
          WHERE clinic_visits.type::text = 'Renalware::Dietetics::ClinicVisit'::text
          ORDER BY clinic_visits.patient_id, clinic_visits.date DESC, clinic_visits.created_at DESC
        ), latest_dry_weights AS (
         SELECT DISTINCT ON (cdw.patient_id) cdw.id,
            cdw.patient_id,
            cdw.weight
           FROM renalware.clinical_dry_weights cdw
          ORDER BY cdw.patient_id, cdw.created_at DESC
        )
 SELECT p.id,
    p.secure_id,
    (upper(p.family_name::text) || ', '::text) || p.given_name::text AS patient_name,
    (named_consultant_user.family_name::text || ', '::text) || named_consultant_user.given_name::text AS consultant_name,
    p.local_patient_id AS hospital_numbers,
    p.sex,
    p.born_on,
    md.name as modality_name,
    latest_dietetic_clinic_visits.bmi,
    (clinic_visit_users.family_name::text || ', '::text) || clinic_visit_users.given_name::text AS dietician_name,
    renalware.convert_to_float((pathology."values" -> 'POT'::text) ->> 'result'::text, NULL::double precision) AS pot,
    renalware.convert_to_float((pathology."values" -> 'PHOS'::text) ->> 'result'::text, NULL::double precision) AS phos,
    renalware.convert_to_float((pathology."values" -> 'PTH'::text) ->> 'result'::text, NULL::double precision) AS pth,
    renalware.convert_to_float((pathology."values" -> 'ALB'::text) ->> 'result'::text, NULL::double precision) AS alb,
    renalware.convert_to_float((pathology."values" -> 'URR'::text) ->> 'result'::text, NULL::double precision) AS urr,
    latest_dietetic_clinic_visits.date AS clinic_visit_date,
    (latest_dietetic_clinic_visits.document ->> 'next_review_on'::text)::date AS next_review_on,
    translate(initcap(latest_dietetic_clinic_visits.document ->> 'assessment_type'::text), '_'::text, ' '::text) AS assessment_type,
    translate(initcap(latest_dietetic_clinic_visits.document ->> 'visit_type'::text), '_'::text, ' '::text) AS visit_type,
    (latest_dietetic_clinic_visits.document ->> 'weight_change'::text) || '%'::text AS weight_change,
    latest_dietetic_clinic_visits.weight AS current_weight,
    latest_dry_weights.weight AS dry_weight,
        CASE
            WHEN ((latest_dietetic_clinic_visits.document ->> 'next_review_on'::text)::date) < now() THEN 'overdue'::text
            WHEN ((latest_dietetic_clinic_visits.document ->> 'next_review_on'::text)::date) < (now() + '1 mon'::interval) THEN 'in 1 months'::text
            WHEN ((latest_dietetic_clinic_visits.document ->> 'next_review_on'::text)::date) < (now() + '3 mons'::interval) THEN 'in 3 months'::text
            WHEN ((latest_dietetic_clinic_visits.document ->> 'next_review_on'::text)::date) < (now() + '6 mons'::interval) THEN 'in 6 months'::text
            ELSE NULL::text
        END AS outstanding_dietetic_visit,
    hospital_centre.name AS hospital_centre,
        CASE
            WHEN pw.id > 0 THEN true
            ELSE false
        END AS on_worryboard
   FROM latest_dietetic_clinic_visits
     JOIN renalware.patients p ON p.id = latest_dietetic_clinic_visits.patient_id
     LEFT JOIN latest_dry_weights ON latest_dry_weights.patient_id = p.id
     JOIN renalware.users clinic_visit_users ON clinic_visit_users.id = latest_dietetic_clinic_visits.created_by_id
     LEFT JOIN renalware.users named_consultant_user ON named_consultant_user.id = p.named_consultant_id
     LEFT JOIN renalware.patient_worries pw ON pw.patient_id = p.id
     LEFT JOIN renalware.pathology_current_observation_sets pathology ON pathology.patient_id = p.id
     left join renalware.modality_modalities mm on mm.patient_id = p.id and mm.ended_on is null
     left join renalware.modality_descriptions md on md.id = mm.description_id
     LEFT JOIN renalware.hospital_centres hospital_centre ON hospital_centre.id = p.hospital_centre_id
  WHERE md.name != 'death'
  ORDER BY latest_dietetic_clinic_visits.date DESC;
