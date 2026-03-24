class MakeHDScheduleDefinitionDaysTextGenerated < ActiveRecord::Migration[7.0]
  def up
    within_renalware_schema do
      safety_assured do
        drop_view :hd_mdm_patients, revert_to_version: 7
        drop_view :hd_schedule_definition_filters, revert_to_version: 1

        execute <<~SQL.squish
          CREATE OR REPLACE FUNCTION hd_schedule_definition_days_text(days integer[])
          RETURNS text
          LANGUAGE sql
          IMMUTABLE
          STRICT
          AS $$
            SELECT string_agg(
              CASE day_number
                WHEN 1 THEN 'Mon'
                WHEN 2 THEN 'Tue'
                WHEN 3 THEN 'Wed'
                WHEN 4 THEN 'Thu'
                WHEN 5 THEN 'Fri'
                WHEN 6 THEN 'Sat'
                WHEN 7 THEN 'Sun'
              END,
              ' ' ORDER BY day_number
            )
            FROM (
              SELECT DISTINCT unnest(days) AS day_number
            ) days
            WHERE day_number BETWEEN 1 AND 7
          $$;
        SQL

        remove_column :hd_schedule_definitions, :days_text, :text

        execute <<~SQL.squish
          ALTER TABLE hd_schedule_definitions
          ADD COLUMN days_text text
          GENERATED ALWAYS AS (hd_schedule_definition_days_text(days)) STORED
        SQL

        create_view :hd_mdm_patients, version: 7
        create_view :hd_schedule_definition_filters, version: 1
      end
    end
  end

  def down
    within_renalware_schema do
      safety_assured do
        drop_view :hd_mdm_patients, revert_to_version: 7
        drop_view :hd_schedule_definition_filters, revert_to_version: 1

        remove_column :hd_schedule_definitions, :days_text, :text
        add_column :hd_schedule_definitions, :days_text, :text

        execute <<~SQL.squish
          UPDATE hd_schedule_definitions
          SET days_text = hd_schedule_definition_days_text(days)
        SQL

        execute <<~SQL.squish
          DROP FUNCTION IF EXISTS hd_schedule_definition_days_text(integer[])
        SQL

        create_view :hd_mdm_patients, version: 7
        create_view :hd_schedule_definition_filters, version: 1
      end
    end
  end
end
