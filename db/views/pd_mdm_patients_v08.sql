select
  distinct on (P.id)
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
  case
    when pw.id > 0 then true
    else false
    end as on_worryboard,
  TXRSD."name" tx_status,
  case pr.type
    when 'Renalware::PD::APDRegime' then 'APD'
    when 'Renalware::PD::CAPDRegime' then 'CAPD'
    end as pd_type,
   (select
       date(date_time)
       from events e
       inner join event_types et on et.id = e.event_type_id
       where et.slug = 'pd_line_changes'
       and e.patient_id = P.id and e.deleted_at is null
       order by date_time desc limit 1) as last_line_change_date,
  pesi.diagnosis_date as last_esi_date,
  ppe.diagnosis_date as last_peritonitis_date,
  (select bmi from clinic_visits cv2 where cv2.patient_id = P.id and bmi > 0 order by date desc limit 1) as bmi,
  convert_to_float(PA.values -> 'HGB' ->> 'result', null) as hgb,
  (PA.values -> 'HGB' ->> 'observed_at')::date as hgb_date,
  convert_to_float(PA.values -> 'URE' ->> 'result', null) as ure,
  (PA.values -> 'URE' ->> 'observed_at')::date as ure_date,
  convert_to_float(PA.values -> 'CRE' ->> 'result', null) as cre,
  (PA.values -> 'CRE' ->> 'observed_at')::date as cre_date,
  convert_to_float(PA.values -> 'EGFR' ->> 'result', null) as egfr,
  (PA.values -> 'POT' ->> 'observed_at')::date as pot_date,
  convert_to_float(PA.values -> 'POT' ->> 'result', null) as pot,
  (named_nurses.family_name::text || ', '::text) || named_nurses.given_name::text AS named_nurse,
  (named_consultants.family_name::text || ', '::text) || named_consultants.given_name::text AS named_consultant,
  H.name AS hospital_centre
from renalware.patients P
left outer join patient_worries pw on pw.patient_id = p.id
left outer join renalware.pathology_current_observation_sets PA on PA.patient_id = P.id
left outer join renalware.renal_profiles RPROF on RPROF.patient_id = P.id
left outer join renalware.transplant_registrations TXR on TXR.patient_id = P.id
left outer join renalware.transplant_registration_statuses TXRS on TXRS.registration_id = TXR.id AND TXRS.terminated_on IS NULL
left outer join renalware.transplant_registration_status_descriptions TXRSD on TXRSD.id = TXRS.description_id
left outer join renalware.pd_regimes pr on pr.patient_id = P.id and pr.start_date <= current_date and pr.end_date is null
left outer join renalware.pd_exit_site_infections pesi on pesi.patient_id = P.id
left outer join pd_peritonitis_episodes ppe on ppe.patient_id = P.id
LEFT JOIN users named_nurses ON named_nurses.id = p.named_nurse_id
LEFT JOIN users named_consultants ON named_consultants.id = p.named_consultant_id
LEFT JOIN hospital_centres H ON H.id = P.hospital_centre_id
inner join renalware.patient_current_modalities Mx on Mx.patient_id = P.id and Mx.modality_code = 'pd'
order by P.id, pr.start_date desc, pr.created_at desc, pesi.diagnosis_date desc, ppe.diagnosis_date desc;
