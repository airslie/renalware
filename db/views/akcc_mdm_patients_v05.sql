select
  P.id,
  P.secure_id,
  (upper(P.family_name) || ', ' || P.given_name) as "patient_name",
  P.nhs_number,
  P.local_patient_id as hospital_numbers,
  P.sex,
  P.born_on,
  date_part('year', age(P.born_on)) as "age",
  RPROF.esrf_on,
  Mx.modality_name,
  aplantype.name AS access_plan,
  aplan.created_at::date AS access_plan_date,
  case when pw.id > 0 then true else false end as on_worryboard,
  (select bmi from clinic_visits where patient_id = P.id and bmi > 0 order by date desc limit 1) as bmi,
  TXRSD."name" tx_status,
  convert_to_float(PA.values -> 'HGB' ->> 'result', null) as hgb,
  (PA.values -> 'HGB' ->> 'observed_at')::date as hgb_date,
  convert_to_float(PA.values -> 'URE' ->> 'result', null) as ure,
  (PA.values -> 'URE' ->> 'observed_at')::date as ure_date,
  convert_to_float(PA.values -> 'CRE' ->> 'result', null) as cre,
  (PA.values -> 'CRE' ->> 'observed_at')::date as cre_date,
  convert_to_float(PA.values -> 'EGFR' ->> 'result', null) as egfr,
  case when TXRSD.code not ilike '%permanent' then true else false end as tx_candidate,
  case
    when (convert_to_float(PA.values->'HGB'->>'result') < 100.0) then '< 100'
    when (convert_to_float(PA.values->'HGB'->>'result') > 130.0) then '> 130'
    else NULL
  end as hgb_range,
  case
    when (convert_to_float(values->'URE'->>'result') >= 30.0) then '>= 30'
    else NULL
  end as urea_range,
 (named_nurses.family_name::text || ', '::text) || named_nurses.given_name::text AS named_nurse,
 (named_consultants.family_name::text || ', '::text) || named_consultants.given_name::text AS named_consultant,
 H.name AS hospital_centre
from renalware.patients P
left join patient_worries pw on pw.patient_id = p.id
left outer join renalware.pathology_current_observation_sets PA on PA.patient_id = P.id
left outer join renalware.renal_profiles RPROF on RPROF.patient_id = P.id
left outer join renalware.transplant_registrations TXR on TXR.patient_id = P.id
left outer join renalware.transplant_registration_statuses TXRS on TXRS.registration_id = TXR.id AND TXRS.terminated_on IS null and TXRS.started_on <= current_date
left outer join renalware.transplant_registration_status_descriptions TXRSD on TXRSD.id = TXRS.description_id
LEFT JOIN users named_nurses ON named_nurses.id = p.named_nurse_id
LEFT JOIN users named_consultants ON named_consultants.id = p.named_consultant_id
LEFT JOIN hospital_centres H ON H.id = P.hospital_centre_id
LEFT JOIN access_plans aplan ON aplan.patient_id = p.id AND aplan.terminated_at IS NULL
LEFT JOIN access_plan_types aplantype ON aplantype.id = aplan.plan_type_id
inner join renalware.patient_current_modalities Mx on Mx.patient_id = P.id and Mx.modality_code = 'low_clearance';
