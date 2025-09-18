class CreateFeedMergeRules < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      create_enum :feed_merge_rule_action,
                  %w(merge merge_and_warn warn_only skip).freeze
      comment = <<~COMMENT.squish
        Specifies actions to take for a specific schema.table when doing a patient merge
        (eg HL7 A34). A * in the table_name indicates all tables in the schema that have a
        patient_id column and are not otherwise specified.
        Possible values are might be to always merge, merge but warn the user that some interaction
        may be required, skip this table etc. See model for details.
      COMMENT
      create_table(:feed_merge_rules, comment: comment) do |t|
        t.string :schema_name, null: false
        t.string :table_name, null: false
        t.enum :action, enum_type: :feed_merge_rule_action, null: false, default: "merge"
        t.timestamps null: false
        t.index %i(schema_name table_name), unique: true
      end
    end
  end
end
