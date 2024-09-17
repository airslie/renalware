class AddIndexOnActionsToMeshOperations < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      safety_assured do
        add_index :letter_mesh_operations, :action
      end
    end
  end
end
