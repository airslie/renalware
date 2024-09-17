class CreateLetterMeshLettersView < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      create_view :letter_mesh_letters
    end
  end
end
