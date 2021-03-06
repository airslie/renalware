class AddLabIdToPathologyRequestDescriptions < ActiveRecord::Migration[4.2]
  def change
    add_column :pathology_request_descriptions, :lab_id, :integer, null: false
    add_foreign_key :pathology_request_descriptions, :pathology_labs, column: :lab_id
  end
end
