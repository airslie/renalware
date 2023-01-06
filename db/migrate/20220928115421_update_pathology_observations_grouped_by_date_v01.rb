class UpdatePathologyObservationsGroupedByDateV01 < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      update_view :pathology_observations_grouped_by_date, version: 2, revert_to_version: 1
    end
  end
end
