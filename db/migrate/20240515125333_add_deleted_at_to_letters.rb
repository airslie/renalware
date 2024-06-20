class AddDeletedAtToLetters < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      safety_assured do
        add_column :letter_letters, :deleted_at, :datetime
        add_index :letter_letters, :deleted_at, where: "deleted_at IS NULL"
        add_column :letter_letters, :deletion_notes, :text
        add_reference :letter_letters,
                      :deleted_by,
                      foreign_key: { to_table: :users },
                      index: true
      end
    end
  end
end
