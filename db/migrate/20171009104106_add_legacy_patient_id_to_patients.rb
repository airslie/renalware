class AddLegacyPatientIdToPatients < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      add_column :patients, :legacy_patient_id, :integer, null: true
      add_index :patients, :legacy_patient_id, unique: true
    end
  end
end
