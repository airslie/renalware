class AddDisplayGroupToObservationDesriptions < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      remove_column :pathology_observation_descriptions, :display_order, :integer
      remove_column :pathology_observation_descriptions, :display_order_letters, :integer

      add_column :pathology_observation_descriptions,
                 :display_group,
                 :integer

      add_column :pathology_observation_descriptions,
                 :display_order,
                 :integer

      add_column :pathology_observation_descriptions,
                 :letter_group,
                 :integer

      add_column :pathology_observation_descriptions,
                 :letter_order,
                 :integer

      # Only allow an obs desc to be in a group exactly once
      add_index :pathology_observation_descriptions,
                [:display_group, :display_order],
                name: :obx_unique_display_grouping

      add_index :pathology_observation_descriptions,
                [:letter_group, :letter_order],
                name: :obx_unique_letter_grouping
    end
  end
end
