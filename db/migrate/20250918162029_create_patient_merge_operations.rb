class CreatePatientMergeOperations < ActiveRecord::Migration[7.0]
  # rubocop:disable Rails/ThreeStateBooleanColumn
  def change
    within_renalware_schema do
      comment = <<~COMMENT.squish
        Belongs to a PatientMerge::Merge and records the result of attempting to update
        a particular table.column that has a foreign key to renalware.patients.id.
        If merged is true, updated_count records how many rows were updated to point to the
        surviving patient (may be 0). The warnings column may contain any warnings that were
        generated during the merge operation. These can be present even if merged is true.
        This list of operations with warnings can be used to inform the user of any
        potential issues they may need to check after the merge.
      COMMENT
      create_table(:patient_merge_operations, comment: comment) do |t|
        t.references :merge,
                     null: false,
                     foreign_key: { to_table: :patient_merge_merges },
                     index: true
        t.string :schema_name, null: false
        t.string :table_name, null: false
        t.string :column_name, null: false
        t.boolean :merged, null: false
        t.integer :updated_count, null: false, default: 0
        t.text :warning
        t.boolean :require_intervention, null: false, default: false
        t.timestamps default: -> { "CURRENT_TIMESTAMP" }, null: false
        t.index %i(merge_id schema_name table_name column_name),
                unique: true,
                name: "index_patient_merge_operations_on_merge_and_schema_and_table"
      end
    end
  end
  # rubocop:enable Rails/ThreeStateBooleanColumn
end
