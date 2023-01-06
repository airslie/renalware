class UpdatePatientSummaries08 < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      update_view :patient_summaries, version: 8, revert_to_version: 7
    end
  end
end
