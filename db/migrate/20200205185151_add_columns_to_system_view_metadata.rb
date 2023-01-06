class AddColumnsToSystemViewMetadata < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_enum :system_view_display_type, %w(tabular)
      create_enum :system_view_category, %w(mdm report)
      remove_column :system_view_metadata, :category, :string
      change_table :system_view_metadata do |t|
        t.enum :display_type, enum_type: :system_view_display_type, default: :tabular, null: false
        t.enum :category, enum_type: :system_view_category, default: :mdm, null: false
      end
    end
  end
end
