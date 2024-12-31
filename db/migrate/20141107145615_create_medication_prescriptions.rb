class CreateMedicationPrescriptions < ActiveRecord::Migration[4.2]
  def change
    create_table :medication_prescriptions do |t|
      t.references :patient,           null: false, foreign_key: true
      t.references :drug,              null: false, foreign_key: true
      t.references :treatable,         polymorphic: true, null: false
      t.string :dose_amount,           null: false
      t.string :dose_unit,             null: false
      t.references :medication_route,  null: false, foreign_key: true
      t.string :route_description
      t.string :frequency, null: false
      t.text :notes
      t.date :prescribed_on, null: false
      t.integer :provider, null: false
      t.timestamps null: false
    end

    add_index(:medication_prescriptions, [:treatable_id, :treatable_type], name: "idx_medication_prescriptions_type")
  end
end
