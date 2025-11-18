class CreateMergeOperationLogs < ActiveRecord::Migration[8.0]
  def change
    within_renalware_schema do
      comment = <<-COMMENT.squish
        Logs of individual record updates made as part of a patient merge operation.
        Each record indicates that a record in some table had its patient_id (or other FK column as
        specified in the merge_operation.column_name) updated from the minor patient to the
        major patient.
      COMMENT
      # rubocop:disable Rails/CreateTableWithTimestamps
      create_table(:patient_merge_logs, comment: comment) do |t|
        t.references :operation, null: false, foreign_key: { to_table: :patient_merge_operations }
        t.integer :id_of_updated_record, null: false
        t.index [:operation_id, :id_of_updated_record],
                name: "index_merge_operation_logs_on_ids"
      end
      # rubocop:enable Rails/CreateTableWithTimestamps
    end
  end
end
