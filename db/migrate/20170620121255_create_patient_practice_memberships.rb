class CreatePatientPracticeMemberships < ActiveRecord::Migration[5.0]
  def change
    # remove_index :patient_practices_primary_care_physicians, :practice_id
    # remove_index :patient_practices_primary_care_physicians, :primary_care_physician_id
    # remove_foreign_key :patient_practices_primary_care_physicians, :practice_id
    # remove_foreign_key :patient_practices_primary_care_physicians, :primary_care_physician_id

    drop_table :patient_practices_primary_care_physicians

    create_table :patient_practice_memberships do |t|
      t.integer :practice_id, null: false, index: true
      t.integer :primary_care_physician_id, null: false, index: true
      t.datetime :deleted_at, index: true
      t.timestamps null: false
    end
    add_foreign_key :patient_practice_memberships,
                    :patient_practices,
                    column: :practice_id
    add_foreign_key :patient_practice_memberships,
                    :patient_primary_care_physicians,
                    column: :primary_care_physician_id
  end
end
