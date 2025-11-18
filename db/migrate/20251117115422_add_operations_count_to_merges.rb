class AddOperationsCountToMerges < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      add_column :patient_merge_merges, :operations_count, :integer, null: false, default: 0
    end
  end
end
