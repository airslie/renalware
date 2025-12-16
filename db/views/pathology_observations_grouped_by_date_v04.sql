-- note we choose one results per patient/group/code/date combination but
-- because we order by obs.result_status which is an enum where the most final result has the lowest
-- value, and updated_at desc, we get the most recent final result if there are multiples.
with x as (
 SELECT distinct on (obr.patient_id, pcg2.name, pod.code, obs.observed_at::date)
   obr.patient_id,
   (obs.observed_at AT TIME ZONE 'UTC' AT TIME ZONE 'Europe/London')::date AS observed_at,
   obs."result",
   pod.code,
   obs.comment,
   pcg2.name AS "group"
   FROM renalware.pathology_observations obs
     JOIN renalware.pathology_observation_requests obr ON obs.request_id = obr.id
     JOIN renalware.pathology_observation_descriptions pod ON obs.description_id = pod.id
     JOIN renalware.pathology_code_group_memberships pcgm2 ON pcgm2.observation_description_id = pod.id
     JOIN renalware.pathology_code_groups pcg2 ON pcg2.id = pcgm2.code_group_id
   order by obr.patient_id, pcg2.name, pod.code, obs.observed_at::date desc, obs.result_status, obs.updated_at desc
)
select x.patient_id,
  x.observed_at  AS observed_at,
  jsonb_object_agg(x.code, ARRAY[x.result, x.comment::character varying] ORDER BY x.observed_at) AS results,
  x.group
  from x
    GROUP BY x.group, x.patient_id, observed_at
ORDER BY x.patient_id, x.group, x.observed_at desc;
