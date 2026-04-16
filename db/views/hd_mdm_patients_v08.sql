SELECT
    p.id,
    p.secure_id,
    (upper(p.family_name::text) || ', '::text) || p.given_name::text AS patient_name,
    p.nhs_number,
    p.local_patient_id AS hospital_numbers,
    p.sex,
    p.born_on,
    rprof.esrf_on,
    latest_op.performed_on AS last_operation_date,
    date_part('year'::text, age(p.born_on::timestamp with time zone))::integer AS age,
    mx.modality_name,
    case when pw.id > 0 then true else false end as on_worryboard,
    at.name AS access,
    (select bmi from clinic_visits cv2 where cv2.patient_id = P.id and bmi > 0 order by date desc limit 1) as bmi,
    ap.started_on AS access_date,
    aplantype.name AS access_plan,
    aplan.created_at::date AS plan_date,
    txrsd.name AS tx_status,
    unit.name AS hospital_unit,
    unit.unit_code AS dialysing_at,
    (named_nurses.family_name::text || ', '::text) || named_nurses.given_name::text AS named_nurse,
    (named_consultants.family_name::text || ', '::text) || named_consultants.given_name::text AS named_consultant,
    H.name AS hospital_centre,
    (((hdp.document -> 'transport'::text) ->> 'has_transport'::text) || ': '::text) || ((hdp.document -> 'transport'::text) ->> 'type'::text) AS transport,
    (sched.days_text || ' '::text) || upper(diurnal.code::text) AS schedule,
    case when hdp.document -> 'dialysis' ->> 'incremental' = 'yes' then true else false end as incremental,
    convert_to_float((pa."values" -> 'HGB'::text) ->> 'result'::text, null) AS hgb,
    ((pa."values" -> 'HGB'::text) ->> 'observed_at'::text)::date AS hgb_date,
    convert_to_float((pa."values" -> 'PHOS'::text) ->> 'result'::text, null) AS phos,
    ((pa."values" -> 'PHOS'::text) ->> 'observed_at'::text)::date AS phos_date,
    convert_to_float((pa."values" -> 'POT'::text) ->> 'result'::text, null) AS pot,
    ((pa."values" -> 'POT'::text) ->> 'observed_at'::text)::date AS pot_date,
    convert_to_float((pa."values" -> 'PTHI'::text) ->> 'result'::text, null) AS pthi,
    ((pa."values" -> 'PTHI'::text) ->> 'observed_at'::text)::date AS pthi_date,
    convert_to_float((pa."values" -> 'URR'::text) ->> 'result'::text, null) AS urr,
    ((pa."values" -> 'URR'::text) ->> 'observed_at'::text)::date AS urr_date,
    latest_vnd.overall_risk_score as vnd_risk_score,
    latest_vnd.overall_risk_level as vnd_risk_level
   FROM patients p
     JOIN patient_current_modalities mx ON mx.patient_id = p.id AND mx.modality_code::text = 'hd'::text
     LEFT JOIN hd_profiles hdp ON hdp.patient_id = p.id AND hdp.deactivated_at IS NULL
     LEFT JOIN hospital_units unit ON unit.id = hdp.hospital_unit_id
     LEFT JOIN users named_nurses ON named_nurses.id = p.named_nurse_id
     LEFT JOIN users named_consultants ON named_consultants.id = p.named_consultant_id
     left join patient_worries pw on pw.patient_id  = p.id
     LEFT JOIN hd_schedule_definitions sched ON sched.id = hdp.schedule_definition_id
     LEFT JOIN hd_diurnal_period_codes diurnal ON diurnal.id = sched.diurnal_period_id
     LEFT JOIN pathology_current_observation_sets pa ON pa.patient_id = p.id
     LEFT JOIN hospital_centres H ON H.id = P.hospital_centre_id
     LEFT JOIN ( SELECT DISTINCT ON (access_profiles.patient_id) access_profiles.id,
            access_profiles.patient_id,
            access_profiles.formed_on,
            access_profiles.started_on,
            access_profiles.terminated_on,
            access_profiles.type_id,
            access_profiles.side,
            access_profiles.notes,
            access_profiles.created_by_id,
            access_profiles.updated_by_id,
            access_profiles.created_at,
            access_profiles.updated_at,
            access_profiles.decided_by_id
           FROM access_profiles
          WHERE access_profiles.terminated_on IS NULL
          ORDER BY access_profiles.patient_id, access_profiles.created_at DESC) ap ON ap.patient_id = p.id
     LEFT JOIN access_types at ON at.id = ap.type_id
     LEFT JOIN access_plans aplan ON aplan.patient_id = p.id AND aplan.terminated_at IS NULL
     LEFT JOIN access_plan_types aplantype ON aplantype.id = aplan.plan_type_id
     LEFT JOIN transplant_registrations txr ON txr.patient_id = p.id
     LEFT JOIN transplant_registration_statuses txrs ON txrs.registration_id = txr.id AND txrs.terminated_on IS NULL
     LEFT JOIN transplant_registration_status_descriptions txrsd ON txrsd.id = txrs.description_id
     LEFT JOIN renal_profiles rprof ON rprof.patient_id = p.id
     LEFT JOIN (
      select distinct on (patient_id) patient_id, overall_risk_score, overall_risk_level
      from hd_vnd_risk_assessments hvra order by patient_id, updated_at desc) latest_vnd ON latest_vnd.patient_id = p.id
     LEFT JOIN ( SELECT DISTINCT ON (transplant_recipient_operations.patient_id) transplant_recipient_operations.patient_id,
            transplant_recipient_operations.performed_on
           FROM transplant_recipient_operations
          ORDER BY transplant_recipient_operations.patient_id, transplant_recipient_operations.performed_on DESC) latest_op ON latest_op.patient_id = p.id;
