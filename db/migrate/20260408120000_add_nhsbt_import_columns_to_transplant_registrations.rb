class AddNhsbtImportColumnsToTransplantRegistrations < ActiveRecord::Migration[8.1]
  def change
    within_renalware_schema do
      safety_assured do
        change_table :transplant_registrations, bulk: true do |t|
          t.string :pancreas_status
          t.date :pancreas_status_date
          t.date :sensi_eval_date
          t.decimal :match_score
          t.decimal :match_points
          t.integer :kidney_waiting_time_days
          t.integer :pancreas_waiting_time_days
          t.datetime :nhsbt_last_imported_at
          t.string :nhsbt_last_import_source
          t.string :nhsbt_last_import_checksum
        end
      end
    end
  end
end
