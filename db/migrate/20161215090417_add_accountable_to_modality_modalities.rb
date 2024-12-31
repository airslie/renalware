class AddAccountableToModalityModalities < ActiveRecord::Migration[4.2]
  def change
    add_column :modality_modalities, :created_by_id, :integer, null: false
    add_column :modality_modalities, :updated_by_id, :integer, null: false
    add_index :modality_modalities, :created_by_id
    add_index :modality_modalities, :updated_by_id

    add_foreign_key "modality_modalities", "users", column: "created_by_id",
                                                    name: "modality_modalities_created_by_id_fk"
    add_foreign_key "modality_modalities", "users", column: "updated_by_id",
                                                    name: "modality_modalities_updated_by_id_fk"
  end
end
