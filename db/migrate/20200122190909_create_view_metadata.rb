class CreateViewMetadata < ActiveRecord::Migration[5.2]
  def change
    enable_extension "hstore"
    within_renalware_schema do
      create_table(
        :system_view_metadata,
        comment: "Holds descriptive and layout data to help us construct " \
                 "data-driven parts of the Renalware UI e.g. MDMs"
      ) do |t|
        t.text :schema_name, null: false
        t.text :view_name, null: false
        t.text :slug, comment: "May be used in urls - must be lower case with no spaces"
        t.text :category, comment: "e.g. MDM"
        t.text :scope, comment: "e.g. PD"
        t.text :parent_name
        t.references(
          :parent,
          index: true,
          foreign_key: { to_table: :system_view_metadata },
          comment: "Self-join in case a view should have children"
        )
        t.text :title, comment: "A label that may appear in the UI"
        t.jsonb(
          :columns,
          comment: "Array of column_names. If empty, all cols displayed. " \
                   "Array order is the display order",
          null: false,
          default: []
        )
        t.jsonb(
          :filters,
          null: false,
          default: [],
          comment: "Array of filter definition for generating filters. " \
                   "Must be the name of a column in the SQL view. "
        )
        t.integer :position, null: false, default: 0
        t.text :description, comment: "A description of the SQL view's function"
        t.timestamps null: false
      end
      add_index :system_view_metadata, %i(category scope slug), unique: true
    end
  end
end
