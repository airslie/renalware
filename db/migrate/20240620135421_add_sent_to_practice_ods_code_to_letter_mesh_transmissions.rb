class AddSentToPracticeODSCodeToLetterMeshTransmissions < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      safety_assured do
        add_column :letter_mesh_transmissions,
                   :sent_to_practice_ods_code,
                   :string
        add_index :letter_mesh_transmissions, :sent_to_practice_ods_code
      end
    end
  end
end
