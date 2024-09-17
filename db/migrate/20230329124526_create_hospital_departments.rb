class CreateHospitalDepartments < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      comment = "Can be assigned for example to a Letters::Letterhead. Useful for e.g. when " \
                "including the sending organisation's details in a GP Connect message."
      create_table :hospital_departments, comment: comment do |t|
        t.string :name, null: false
        t.text :description
        t.references :hospital_centre, foreign_key: true, null: false, index: true
        t.datetime :deleted_at, index: true
        t.timestamps null: false
      end
    end
  end
end
