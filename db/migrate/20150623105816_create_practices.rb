class CreatePractices < ActiveRecord::Migration[4.2]
  def change
    create_table :doctor_practices do |t|
      t.string :name, null: false
      t.string :email
      t.string :code, null: false

      t.timestamps null: false
    end

    create_table :doctor_doctors_practices, id: false do |t|
      t.references :doctor, :practice, null: false
    end

    add_foreign_key :doctor_doctors_practices, :doctor_doctors, column: :doctor_id
    add_foreign_key :doctor_doctors_practices, :doctor_practices, column: :practice_id

    add_index :doctor_doctors_practices, [:doctor_id, :practice_id], name: "index_doctors_practices"
  end
end
