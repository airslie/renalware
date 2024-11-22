/* Among all patients with send_to_renal_reg = false and where no explicit
 * decision has been made to opt them out, set send_to_renal_reg = true if
 * their modality is Transplant or HD or PD, or their modality is
 * low_clearance or nephrology and they have an egfr < 30
 */
create or replace function renalware_demo.ukrdc_update_send_to_renalreg(
  OUT records_added integer,
  OUT records_updated integer)
RETURNS record
as $$
declare countOfUpdatedRows int = 0;
BEGIN
  with candidates as(
    select
        p.id as patient_id,
        convert_to_float(pcos.values -> 'EGFR' ->> 'result', null) as egfr,
        md.code as modality_code
    from
        renalware.patients p
        inner join renalware.patient_current_modalities pcm on pcm.patient_id = p.id
        left join renalware.pathology_current_observation_sets pcos on pcos.patient_id = p.id
        inner join modality_descriptions md on md.id = pcm.modality_description_id
    where
        p.send_to_renalreg = false
        and p.renalreg_decision_on is null
        and md.code in ('transplant', 'pd', 'hd', 'low_clearance', 'nephrology')
  ),
  updateables as (
    select patient_id, egfr, modality_code from candidates
    where
      modality_code in ('transplant', 'pd', 'hd')
      or (modality_code in ('low_clearance', 'nephrology') and egfr < 30.0)
  )
  update renalware.patients p
    set
        send_to_renalreg = true,
        renalreg_decision_on = now(),
        renalreg_recorded_by = 'Renalware System'
    from updateables
    where updateables.patient_id = p.id;

  -- Return the number of updated rows in records_updated
  GET DIAGNOSTICS countOfUpdatedRows = ROW_COUNT;
  select into records_added, records_updated 0, countOfUpdatedRows;
END
$$ LANGUAGE plpgsql;
