class CreatePDTrainingTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :pd_training_types do |t|
      t.string :name, null: false
      t.datetime :deleted_at

      t.timestamps null: false
    end

    add_reference :pd_training_sessions, :training_type,
                  references: :pd_training_types, null: false, index: true

    add_foreign_key "pd_training_sessions", "pd_training_types",
                    column: "training_type_id", name: "pd_training_sessions_type_id_fk"
  end
end
