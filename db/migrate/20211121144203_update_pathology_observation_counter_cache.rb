class UpdatePathologyObservationCounterCache < ActiveRecord::Migration[5.2]
  def up
    execute(<<~SQL.squish)
      UPDATE renalware.pathology_observation_descriptions pod
      set observations_count = (
        select count(*) from renalware.pathology_observations where description_id = pod.id
      );
    SQL
  end

  def down
    # noop
  end
end
