class AddSubCategoryToSystemViewMetadata < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      add_column :system_view_metadata, :sub_category, :string, index: true
    end
  end
end
