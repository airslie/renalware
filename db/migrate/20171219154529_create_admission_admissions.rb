class CreateAdmissionAdmissions < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      create_table :admission_admissions do |t|
        t.references :hospital_ward, foreign_key: true, index: true, null: false
        t.references :patient, foreign_key: true, index: true, null: false
        t.date :admitted_on, null: false, index: true
        t.string :admission_type, null: false
        t.string :consultant
        t.references :modality_at_admission,
                     foreign_key: { to_table: :modality_modalities },
                     index: true
        t.text :reason_for_admission, null: false
        t.text :notes
        t.date :transferred_on
        t.string :transferred_to
        t.date :discharged_on, index: true
        t.string :discharge_destination
        t.string :destination_notes
        t.text :discharge_summary
        t.date :summarised_on
        t.references :summarised_by, foreign_key: { to_table: :users }, index: true
        t.references :updated_by, foreign_key: { to_table: :users }, index: true, null: false
        t.references :created_by, foreign_key: { to_table: :users }, index: true, null: false
        t.datetime :deleted_at, index: true
        t.timestamps null: false
      end
    end
  end
end
