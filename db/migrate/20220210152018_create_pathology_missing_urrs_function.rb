class CreatePathologyMissingUrrsFunction < ActiveRecord::Migration[6.0]
  def up
    within_renalware_schema do
      load_function("pathology_missing_urrs_v01.sql")
    end
  end

  def down
    within_renalware_schema do
      connection.execute(<<~SQL.squish)
        DROP FUNCTION IF EXISTS renalware.pathology_missing_urrs(
          int, int, varchar, varchar, varchar
        );
      SQL
    end
  end
end
