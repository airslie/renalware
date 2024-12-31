class AddLabIdToPathologyRequestAlgorithmPatientRules < ActiveRecord::Migration[4.2]
  def change
    remove_column :pathology_request_algorithm_patient_rules, :lab
    add_column :pathology_request_algorithm_patient_rules, :lab_id, :integer
    add_foreign_key :pathology_request_algorithm_patient_rules, :pathology_labs,
                    column: :lab_id
  end
end
