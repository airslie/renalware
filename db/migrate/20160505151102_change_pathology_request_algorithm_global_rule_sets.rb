class ChangePathologyRequestAlgorithmGlobalRuleSets < ActiveRecord::Migration[4.2]
  def change
    remove_foreign_key :pathology_request_algorithm_global_rule_sets,
                       column: :observation_description_id

    rename_column :pathology_request_algorithm_global_rule_sets, :observation_description_id,
                  :request_description_id

    add_foreign_key :pathology_request_algorithm_global_rule_sets,
                    :pathology_request_descriptions, column: :request_description_id
  end
end
