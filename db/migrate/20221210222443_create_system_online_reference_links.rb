class CreateSystemOnlineReferenceLinks < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      create_table :system_online_reference_links do |t|
        t.string(
          :title,
          null: false,
          index: { unique: true },
          comment: "The name of this resource, for display in the UI only"
        )
        t.string(
          :url,
          null: false,
          index: { unique: true },
          comment: "A URL linking to a helpful online reference for patients. May be rendered as a QR code."
        )
        t.text :description, comment: "Text displayed alongside the link or QR code"
        t.integer :usage_count, default: 0
        t.datetime :last_used_at
        t.references :created_by, index: true, null: false, foreign_key: { to_table: :users }
        t.references :updated_by, index: true, null: false, foreign_key: { to_table: :users }
        t.timestamps null: false
      end
    end
  end
end
