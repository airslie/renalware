class AddTypistToMeshLettersView < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      update_view :letter_mesh_letters, version: 2, revert_to_version: 1
    end
  end
end
