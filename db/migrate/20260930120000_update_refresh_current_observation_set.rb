class UpdateRefreshCurrentObservationSet < ActiveRecord::Migration[7.0]
  def up
    within_renalware_schema do
      load_function("refresh_current_observation_set_v02.sql")
    end
  end

  def down
    within_renalware_schema do
      load_function("refresh_current_observation_set_v01.sql")
    end
  end
end
