class AddColumnsToPatients < ActiveRecord::Migration[5.0]
  def change
    reversible do |direction|
      direction.up { change_column :patients, :local_patient_id, :string, null: true }
      direction.down { change_column :patients, :local_patient_id, :string, null: false }
    end

    add_column :patients, :local_patient_id_2, :string
    add_column :patients, :local_patient_id_3, :string
    add_column :patients, :local_patient_id_4, :string
    add_column :patients, :local_patient_id_5, :string
    add_column :patients, :external_patient_id, :string

    add_index :patients, :local_patient_id
    add_index :patients, :local_patient_id_2
    add_index :patients, :local_patient_id_3
    add_index :patients, :local_patient_id_4
    add_index :patients, :local_patient_id_5
    add_index :patients, :external_patient_id
  end
end
