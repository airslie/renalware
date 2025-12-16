class UpdatePathologyObservationsGroupedByDateV04 < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      update_view :pathology_observations_grouped_by_date, version: 4, revert_to_version: 3
    end
  end
end
