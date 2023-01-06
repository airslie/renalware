select
obr.patient_id,
observed_at::date,
jsonb_object_agg(pod.code, ARRAY[obs.result, obs.comment] order by observed_at asc) results,
pcg2.name as group
from renalware.pathology_observations obs
inner join renalware.pathology_observation_requests obr on obs.request_id = obr.id
inner join renalware.pathology_observation_descriptions pod on obs.description_id = pod.id
inner join renalware.pathology_code_group_memberships pcgm2 on pcgm2.observation_description_id = pod.id
inner join renalware.pathology_code_groups pcg2 on pcg2.id = pcgm2.code_group_id
group by (pcg2.name, patient_id,  observed_at::date)
order by patient_id asc, pcg2.name, observed_at desc;
