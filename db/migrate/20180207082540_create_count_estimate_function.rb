class CreateCountEstimateFunction < ActiveRecord::Migration[5.1]
  def up
    within_renalware_schema do
      load_function "count_estimate_v01.sql"
    end
  end

  def down
    within_renalware_schema do
      connection.execute("DROP FUNCTION IF EXISTS count_estimate(text);")
    end
  end
end
