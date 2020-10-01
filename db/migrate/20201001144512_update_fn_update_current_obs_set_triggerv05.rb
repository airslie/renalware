class UpdateFnUpdateCurrentObsSetTriggerv05 < ActiveRecord::Migration[5.2]
  def up
    within_renalware_schema do
      load_function("update_current_observation_set_from_trigger_v05.sql")
    end
  end

  def down
    within_renalware_schema do
      load_function("update_current_observation_set_from_trigger_v04.sql")
    end
  end
end
