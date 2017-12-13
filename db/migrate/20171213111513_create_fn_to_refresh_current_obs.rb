class CreateFnToRefreshCurrentObs < ActiveRecord::Migration[5.1]
  def up
    sql = <<-SQL.squish
      CREATE OR REPLACE FUNCTION refresh_current_observation_sets_for_all_patients()
          RETURNS text
          LANGUAGE 'plpgsql'
          as $$
        BEGIN
        with current_patient_obs as(
            select
              DISTINCT ON (p.id, obxd.id)
              p.id as patient_id,
              obxd.code,
              json_build_object('result',(obx.result),'observed_at',obx.observed_at) as value
              from patients p
              inner join pathology_observation_requests obr on obr.patient_id = p.id
              inner join pathology_observations obx on obx.request_id = obr.id
              inner join pathology_observation_descriptions obxd on obx.description_id = obxd.id
              order by p.id, obxd.id, obx.observed_at desc
          ),
          current_patient_obs_as_jsonb as (
            select patient_id,
              jsonb_object_agg(code, value) as values,
              CURRENT_TIMESTAMP,
              CuRRENT_TIMESTAMP
              from current_patient_obs
              group by patient_id order by patient_Id
          )
          insert into pathology_current_observation_sets (patient_id, values, created_at, updated_at)
            select * from current_patient_obs_as_jsonb
            ON conflict (patient_id)
            DO UPDATE
            SET values = excluded.values, updated_at = excluded.updated_at;
          return 'ok';
      END
      $$;
    SQL

    ActiveRecord::Base.connection.execute(sql)
  end

  def down
    ActiveRecord::Base.connection.execute("drop function refresh_current_observation_sets_for_all_patients()")
  end
end
