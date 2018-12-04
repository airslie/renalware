class CreatePatientVersions < ActiveRecord::Migration[5.0]
  def change
    create_table :patient_versions do |t|
      t.string   :item_type, null: false
      t.integer  :item_id,   null: false
      t.string   :event,     null: false
      t.string   :whodunnit
      t.jsonb    :object
      t.jsonb    :object_changes
      t.datetime :created_at
    end
    add_index :patient_versions,
              [:item_type, :item_id],
              name: "patient_versions_versions_type_id"
  end
end
