class CreateTransplantVersions < ActiveRecord::Migration[4.2]
  def change
    create_table :transplant_versions do |t|
      t.string   :item_type, null: false
      t.integer  :item_id,   null: false
      t.string   :event,     null: false
      t.string   :whodunnit
      t.jsonb    :object
      t.jsonb    :object_changes
      t.datetime :created_at
    end
    add_index :transplant_versions, [:item_type, :item_id],
              name: "tx_versions_type_id"
  end
end
