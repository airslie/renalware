class UpdatePatientSummaries09 < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      update_view :patient_summaries, version: 9, revert_to_version: 8
    end
  end
end
