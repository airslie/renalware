CREATE OR REPLACE FUNCTION patient_nag_clinical_frailty_score(
    p_id integer,
    out out_severity system_nag_severity, -- eg 'high'
    out out_value text, -- eg a score etc like '7' or 'Missing' etc
    out out_date date -- eg a date if one has been resolved (will be nil if out_vaole is 'Missing')
)
AS $$
declare
    event_age_in_days integer;
    modality_code text;
begin
    /* A nag function which is used in the UI to display a nag on patient ages if a CFS score is
     * missing or out of date. A CFS score is recorded in the UI by creating an event of type
     * 'Clinical Frailty Score'.
     *
     * Returns:
     * - out_severity eg 'high' - see the system_nag_severity type
     * - out_value - the CFS score, or 'Missing' if no score recorded yet
     * - out_date - the date of the most recent CFS event, if one found
     *
     * The logic is:
     * - Patient modality not in HD PD Tx : out_severity = none, out_value = last CFS score, out_date = last CFS date*
     * - No CFS : out_severity = high, out_value = 'Missing', out_date = null
     * - CSF older than 180 days : out_severity = high, out_value = last CFS score, out_date = last CFS date
     * - CSF age is >=90 <180 days : out_severity = medium, out_value = last CFS score, out_date = last CFS date
     * - CSF recorded within 90 days : out_severity = none, out_value = last CFS score, out_date = last CFS date
     */
    select into
        event_age_in_days
        ,out_date
        ,out_value
        current_date - e.date_time::date -- eg 90 days, an integer
        ,date_time
        ,document ->> 'score'
    from events e
    inner join event_types et on et.id = e.event_type_id
    where e.patient_id = p_id 
      and e.deleted_at is null
      and et.slug = 'clinical_frailty_score'
    order by e.date_time desc
    limit 1;

    select into modality_code pcm.modality_code
    from patient_current_modalities pcm
    where pcm.patient_id = p_id;

    select into out_value coalesce(out_value, 'Missing');

    select into out_severity
        case
            when modality_code is NULL then 'none'
            when modality_code not in ('pd', 'hd', 'transplant') then 'none'
            when event_age_in_days is NULL then 'high' -- missing CSF event
            else
                case
                    when event_age_in_days > 180 then 'high'
                    when event_age_in_days >= 90 then 'medium'
                    else 'none'
                end
            end;
 end
$$
LANGUAGE plpgsql
STABLE;
