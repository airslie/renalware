class CreatePatientMergeRules < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      comment = <<~COMMENT.squish
        Specifies actions to take for a specific schema.table when doing a patient merge
        (eg HL7 A34). A * in the table_name indicates all tables in the schema that have a
        patient_id column and are not otherwise specified.
        Possible values are eg to merge silently, merge but warn the user that some interaction
        may be required, skip this table etc. See model for details.
      COMMENT
      create_table(:patient_merge_rules, comment: comment) do |t|
        t.string :schema_name, null: false
        t.string :table_name, null: false
        t.boolean :merge, null: false, default: true
        t.text :warning_message, comment: "Displayed to the user if present after a merge"
        t.timestamps default: -> { "CURRENT_TIMESTAMP" }, null: false
        t.index %i(schema_name table_name), unique: true
      end
    end
  end
end
