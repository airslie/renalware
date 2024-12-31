class CreatePatientWorries < ActiveRecord::Migration[5.0]
  def change
    create_table :patient_worries do |t|
      t.references :patient, null: false, foreign_key: true, index: { unique: true }
      t.integer :updated_by_id, null: false, index: true
      t.integer :created_by_id, null: false, index: true
      t.timestamps null: false
    end

    add_foreign_key :patient_worries, :users, column: :created_by_id
    add_foreign_key :patient_worries, :users, column: :updated_by_id
  end
end
