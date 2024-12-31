class AddLetterDateIndexes < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      add_index :letter_letters, :created_at
      add_index :letter_letters, :submitted_for_approval_at
      add_index :letter_letters, :approved_at
      add_index :letter_letters, :completed_at
      add_index :letter_letters,
                "(COALESCE(completed_at, approved_at, submitted_for_approval_at, created_at))",
                name: "letter_effective_date_idx"
    end
  end
end
