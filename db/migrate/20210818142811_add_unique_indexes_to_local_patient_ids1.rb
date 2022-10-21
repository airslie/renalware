class AddUniqueIndexesToLocalPatientIds1 < ActiveRecord::Migration[5.2]
  def change
    # Removing local_patient_id from uniq index migration as it causes issues at Barts where there
    # are ~100 patients with a non-unique local_patient_id.
    # local_patient_id can be added back into the array in this migration once it has been run in
    # a BLT
    within_renalware_schema do
      %i(
        local_patient_id_2
        local_patient_id_3
        local_patient_id_4
        local_patient_id_5
      ).each do |col|
        # Drop the existing index and add a new unique one
        remove_index(:patients, col)
        add_index(:patients, col, unique: true)
      end
    end
  end
end
