class CreateSystemHelpFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :system_help do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :description
      t.datetime :deleted_at, index: true
      t.references :updated_by, foreign_key: { to_table: :users }, index: true, null: false
      t.references :created_by, foreign_key: { to_table: :users }, index: true, null: false
      t.timestamps null: false
    end
  end
end
