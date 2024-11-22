---
title: Creating Nags
---

# Patient Nags

Patient nags are alerts that appear at the top of a patient's pages to indicate missing or
out-of-date data - for example they have not had a clinical frailty score in the last 180 days.

## Nag SQL functions

Nags are implemented as discrete SQL functions in PostgreSQL. The function must have the following
signature, accepting on input (p_id) and in the function populating 2 variables to be returned
to Renalware (hence the OUT modifier):

```
CREATE OR REPLACE FUNCTION patient_nag_<name_of_nag>(
    p_id integer,
    OUT out_severity system_nag_severity,
    OUT out_date date
    OUT out_value text
)
```

| Argument | Description |
| --- | -- |
| `p_id` | the patient's primary key id in the patient's table (this is not an NHS or hospital number) |
| `out_severity` | this variable must be populated with one of the values below |
| `out_date` | optional date eg an event date |
| `out_value` | optional value eg some value from an event |


### Nag Severity

| Name | Description |
| --- | ---- |
| `'none'` | the nag will not be displayed |
| `'info'` | the nag will always be displayed (provided value or date are not null) for info only. Arguably not a nag in this instance. |
| `'low'` | nag will display with a yellow background |
| `'medium'` | nag will display with an orange background |
| `'high'` | nag will display with a red background |

> For an example nag search the code for patient_nag_clinical_frailty_score.

## Nag Definitions

For a nag to appear, it must have an entry in the nag_definitions table. You can edit this in the
Admin UI if you are are superadmin, or directly through in the database table.
When adding a nag in the UI, your function will only appear in the dropdown if it is named correctly
(see above).

| Column | Description |
| --- | ----------- |
| `scope` | There are patient and user scope nags. Only patient scope nags are currently implenented. |
| `importance` | An integer where the lowest number appears first when > 1 nag is dislpayed |
| `description` | Does not appear on screen but can be used remind you what the nag does |
| `hint` | Appears when hovering over the nag |
| `sql_function_name` | The function described above |
| `title` | A string that appears in the nag e.g. as a prefix to the content eg 'CFS' in 'CFS: 01-Apr-2020' |
| `enabled` | Set to false to hide the nag |
| `relative_link` | If present, the title will become a link a location in renalware. Use a placeholder for patient id. For example if the nag shold be resolved byu adding an event to the patient, use `patients/:id/events` |
| `always_expire_cache_after_minutes` | Nags cache (to improve performance) until their cause is resolved or until this number of minutes has elapsed, after which the SQL funcion is called again to refresh the on-screen nag. You can lower this number if nags are not dismissing after the user has resolved the nag cause|


## Caching

Once rendered, a nag is cached until:

- the patient's updated_at date changes (ie the patient record has been `touched` in some way,
perhaps by an event being added)
- the nag definition has been updated (resulting in its updated_at datetime changing)
- the nag cache expires - TODO

Caching nags is useful because they can be 'expensive' in terms of processing time and therefore affect page rendering times.

## Trouble shooting

### Nag not appearing
- Check you are not returning 'none' in the severity from your function.
- Check the nag_definition is not enabled=false.

### Nag not dismissing once issue resolved

It is possible the action the user took did not cause the patient record to be touched. Please report this as a bug.
To remendy the situation, please update the nag_definition updated_at by using the Touch button under the Admin -> Nags, or manually in the database.
You can also touch the patient in Renalware by e.g. updating their demographics.

If the problem happens regularly you can update `nag_definitions.always_expire_cache_after_minutes` to be a lower number.

### Nag not changing after udpating the SQL function behind it

Be sure to update `nag_definitons.updated_at` to invalidate the cache for this nag.
