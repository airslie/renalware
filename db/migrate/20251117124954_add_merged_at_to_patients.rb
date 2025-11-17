class AddMergedAtToPatients < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      safety_assured do
        add_column :patients, :merged_at, :datetime
        add_index :patients, :merged_at, where: "merged_at IS NULL"
      end
    end
  end
end
