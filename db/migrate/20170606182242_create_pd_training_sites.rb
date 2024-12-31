class CreatePDTrainingSites < ActiveRecord::Migration[5.0]
  def change
    create_table :pd_training_sites do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.datetime :deleted_at

      t.timestamps null: false
    end

    add_foreign_key "pd_training_sessions", "pd_training_sites",
                    column: "training_site_id", name: "pd_training_sessions_site_id_fk"
  end
end
