class AddMissingPrescriptionIndexes < ActiveRecord::Migration[4.2]
  def change
    add_index :medication_prescriptions, :created_by_id
    add_index :medication_prescriptions, :updated_by_id
    add_index :medication_prescriptions, :patient_id
    add_index :medication_prescriptions, :drug_id
    add_index :medication_prescriptions, :medication_route_id
    add_index :medication_prescriptions, [:patient_id, :medication_route_id], name: "idx_mp_patient_id_medication_route_id"
    add_index :medication_prescriptions, [:drug_id, :patient_id]
  end
end
