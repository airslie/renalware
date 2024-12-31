class CreateTransplantDonorFollowups < ActiveRecord::Migration[4.2]
  def change
    create_table :transplant_donor_followups do |t|
      t.integer :operation_id, null: false
      t.text :notes

      t.boolean :followed_up
      t.string :ukt_center_code
      t.date :last_seen_on
      t.boolean :lost_to_followup
      t.boolean :transferred_for_followup
      t.date :dead_on

      t.timestamps null: false
    end

    add_index :transplant_donor_followups, :operation_id

    add_foreign_key :transplant_donor_followups, :transplant_donor_operations,
                    column: :operation_id
  end
end
