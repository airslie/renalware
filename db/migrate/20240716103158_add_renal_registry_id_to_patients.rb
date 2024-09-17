class AddRenalRegistryIdToPatients < ActiveRecord::Migration[7.1]
  def change
    safety_assured do
      within_renalware_schema do
        add_column :patients, :renal_registry_id, :string
        add_index :patients, :renal_registry_id, unique: true
      end
    end
  end
end
