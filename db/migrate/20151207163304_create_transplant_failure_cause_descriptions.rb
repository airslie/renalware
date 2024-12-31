class CreateTransplantFailureCauseDescriptions < ActiveRecord::Migration[4.2]
  def change
    create_table :transplant_failure_cause_descriptions do |t|
      t.integer :group_id
      t.string :code, null: false
      t.string :name

      t.timestamps null: false
    end

    add_index :transplant_failure_cause_descriptions, :code, unique: true
    add_foreign_key :transplant_failure_cause_descriptions,
                    :transplant_failure_cause_description_groups,
                    column: :group_id
  end
end
