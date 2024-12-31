class CreateTransplantRecipientFollowups < ActiveRecord::Migration[4.2]
  def change
    create_table :transplant_recipient_followups do |t|
      t.integer :operation_id, null: false
      t.text :notes

      t.date :stent_removed_on
      t.boolean :transplant_failed
      t.date :transplant_failed_on
      t.integer :transplant_failure_cause_description_id
      t.string :transplant_failure_cause_other
      t.text :transplant_failure_notes

      t.jsonb :document

      t.timestamps null: false
    end

    add_index :transplant_recipient_followups, :operation_id
    add_index :transplant_recipient_followups, :document, using: :gin

    add_foreign_key :transplant_recipient_followups, :transplant_recipient_operations,
                    column: :operation_id
    add_foreign_key :transplant_recipient_followups, :transplant_failure_cause_descriptions,
                    column: :transplant_failure_cause_description_id
  end
end
