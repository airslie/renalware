class CreatePathologyRequestAlgorithmGlobalRuleSets < ActiveRecord::Migration[4.2]
  def change
    create_table :pathology_request_algorithm_global_rule_sets do |t|
      t.string :regime, null: false
      t.integer :observation_description_id, null: false
      t.string :frequency, null: false
    end
    add_foreign_key :pathology_request_algorithm_global_rule_sets,
                    :pathology_observation_descriptions, column: :observation_description_id
  end
end
