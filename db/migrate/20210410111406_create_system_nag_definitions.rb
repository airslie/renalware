class CreateSystemNagDefinitions < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_enum :system_nag_definition_scope, %w(patient user)
      create_enum :system_nag_severity, %w(none info low medium high)

      create_table(
        :system_nag_definitions,
        comment: "Registers a 'missing data nag' sql function and the text to " \
                 "display if the function evaluates to true"
      ) do |t|
        t.enum :scope, enum_type: :system_nag_definition_scope, null: false
        t.integer :importance, null: false, default: 1
        t.text :description, null: false, index: { unique: true }
        t.text :hint, comment: "May be displayed when hovering over the nag"
        t.text :sql_function_name, null: false
        t.text(
          :title,
          null: true,
          comment: "If present, text eg ('CFS:') displayed to the left of the content in a nag"
        )
        t.boolean :enabled, default: true, null: false, index: true
        t.text :relative_link
        t.integer(
          :always_expire_cache_after_minutes,
          null: false,
          default: 60, # 1 hour by default
          comment: "Number of minutes to cache this nag before the cache is automatically " \
                   "invalidated. The cache may be invalidated earlier if the " \
                   "nag_definition.updated_at or patient.updated_at timestamps change."
        )
        t.timestamps null: false
      end

      add_index :system_nag_definitions, [:scope, :importance]
    end
  end
end
