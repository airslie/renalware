class AddNresultToPathologyObservations < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column(
        :pathology_observations,
        :nresult,
        :float,
        index: false,
        null: true,
        comment: "The result column cast to a float, for ease of using graphing and claculations." \
                 "Will be null if the result has a text value that cannot be coreced into a number"
      )

      reversible do |direction|
        direction.up do
          load_function("update_pathology_observations_nresult_from_trigger_v01.sql")
          load_trigger("update_pathology_observations_nresult_trigger_v01.sql")
        end
        direction.down do
          connection.execute(
            "DROP TRIGGER IF EXISTS update_pathology_observations_nresult_trigger " \
            "ON pathology_observations; " \
            "DROP FUNCTION IF EXISTS update_pathology_observations_nresult_from_trigger();"
          )
        end
      end
    end
  end
end
