CREATE OR REPLACE FUNCTION refresh_current_observation_set(a_patient_id integer)
  RETURNS integer
  LANGUAGE plpgsql
AS $$
BEGIN
  -- Rebuild from the latest non-empty result for each code, including clearing a
  -- stale snapshot when no results remain. Pause pathology writes during bulk
  -- rebuilds so a concurrent trigger update cannot be overwritten.
  WITH current_patient_obs AS (
    SELECT DISTINCT ON (obx.description_id)
      obxd.code,
      jsonb_build_object(
        'result', obx.result,
        'observed_at', obx.observed_at AT TIME ZONE 'UTC' AT TIME ZONE 'Europe/London'
      ) AS value
    FROM pathology_observation_requests obr
    INNER JOIN pathology_observations obx ON obx.request_id = obr.id
    INNER JOIN pathology_observation_descriptions obxd ON obxd.id = obx.description_id
    WHERE obr.patient_id = a_patient_id AND obx.result <> ''
    -- For equal observation times, prefer the most recently changed row, then
    -- creation time and ID. SQL corrections must maintain updated_at for this
    -- to reflect correction order; historic write order cannot be recovered.
    ORDER BY obx.description_id, obx.observed_at DESC,
      obx.updated_at DESC, obx.created_at DESC, obx.id DESC
  )
  INSERT INTO pathology_current_observation_sets (patient_id, values, created_at, updated_at)
    SELECT p.id,
      COALESCE((SELECT jsonb_object_agg(code, value) FROM current_patient_obs), '{}'::jsonb),
      CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
    FROM patients p
    WHERE p.id = a_patient_id
  ON CONFLICT (patient_id) DO UPDATE
    SET values = excluded.values, updated_at = excluded.updated_at;

  RETURN a_patient_id;
END
$$;
