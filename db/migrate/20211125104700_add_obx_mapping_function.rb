class AddOBXMappingFunction < ActiveRecord::Migration[5.2]
  def up
    load_function("pathology_resolve_observation_description_v01.sql")
  end

  def down
    connection.execute(<<~SQL.squish)
      DROP FUNCTION IF EXISTS
        renalware.pathology_resolve_observation_description(varchar,varchar);
    SQL
  end
end
