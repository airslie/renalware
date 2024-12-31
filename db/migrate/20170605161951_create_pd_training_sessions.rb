class CreatePDTrainingSessions < ActiveRecord::Migration[5.0]
  def change
    create_table :pd_training_sessions do |t|
      t.references :patient, null: false, foreign_key: true, index: true
      t.references :training_site, null: false, index: true
      t.jsonb :document
      t.references :created_by, index: true, null: false
      t.references :updated_by, index: true, null: false
      t.timestamps null: false
    end

    add_foreign_key :pd_training_sessions, :users, column: :created_by_id
    add_foreign_key :pd_training_sessions, :users, column: :updated_by_id
  end
end
