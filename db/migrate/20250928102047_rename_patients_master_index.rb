class RenamePatientsMasterIndex < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      safety_assured do
        remove_index :patient_master_index, [:family_name, :given_name]
        rename_table :patient_master_index, :patient_master_index_deprecated
      end
    end
  end
end
