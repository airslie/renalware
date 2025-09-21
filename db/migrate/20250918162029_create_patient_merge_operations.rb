class CreatePatientMergeOperations < ActiveRecord::Migration[7.0]
  # rubocop:disable Rails/ThreeStateBooleanColumn
  def change
    within_renalware_schema do
      create_table :patient_merge_operations do |t|
        t.references :merge,
                     null: false,
                     foreign_key: { to_table: :patient_merge_merges },
                     index: true
        t.string :schema_name, null: false
        t.string :table_name, null: false
        t.boolean :merged, null: false
        t.integer :updated_count, null: false, default: 0
        t.text :warning
        t.boolean :require_intervention, null: false, default: false
        t.timestamps default: -> { "CURRENT_TIMESTAMP" }, null: false
        t.index %i(merge_id schema_name table_name),
                unique: true,
                name: "index_patient_merge_operations_on_event_and_table"
      end
    end
  end
  # rubocop:enable Rails/ThreeStateBooleanColumn
end
