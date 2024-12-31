class AddForeignKeysToPathologyTables < ActiveRecord::Migration[4.2]
  def change
    add_foreign_key :pathology_request_algorithm_global_rules,
                    :pathology_request_algorithm_global_rule_sets, column: :global_rule_set_id
  end
end
