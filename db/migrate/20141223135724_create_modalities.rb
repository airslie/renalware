class CreateModalities < ActiveRecord::Migration[4.2]
  def change
    create_table :modality_modalities do |t|
      t.references :patient,       null: false, foreign_key: true
      t.belongs_to :description,   null: false, index: true
      t.belongs_to :reason,        index: true
      t.string :modal_change_type
      t.text :notes
      t.date :started_on, null: false
      t.date :ended_on
      t.string :state, null: false, default: "current"
      t.timestamps null: false
    end
    add_foreign_key :modality_modalities,
                    :modality_descriptions, column: :description_id
    add_foreign_key :modality_modalities,
                    :modality_reasons, column: :reason_id
  end
end
