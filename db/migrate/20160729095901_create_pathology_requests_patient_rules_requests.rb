class CreatePathologyRequestsPatientRulesRequests < ActiveRecord::Migration[4.2]
  def change
    create_table :pathology_requests_patient_rules_requests do |t|
      t.integer :request_id, null: false
      t.integer :patient_rule_id, null: false
    end

    add_foreign_key :pathology_requests_patient_rules_requests, :pathology_requests_requests,
                    column: :request_id
    add_foreign_key :pathology_requests_patient_rules_requests, :pathology_requests_patient_rules,
                    column: :patient_rule_id
  end
end
