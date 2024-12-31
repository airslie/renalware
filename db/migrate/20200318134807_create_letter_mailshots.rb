class CreateLetterMailshots < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_table(
        :letter_mailshot_mailshots,
        comment: "A mailshot is an adhoc letter sent to a group of patients"
      ) do |t|
        t.string(
          :description,
          null: false,
          comment: "Some text to identify the mailshot purpose. " \
                   "Will be written to letter_letters.description column when letter created"
        )
        t.string(
          :sql_view_name,
          null: false,
          comment: "The name of the SQL view chosen as the data source"
        )
        t.text(
          :body,
          null: false,
          comment: "The body text that will be inserted into each letter"
        )
        t.references :letterhead, foreign_key: { to_table: :letter_letterheads }, null: false
        t.references :author, foreign_key: { to_table: :users }, index: true, null: false
        t.integer :letters_count, comment: "Counter cache column which Rails will update"
        t.references :created_by, foreign_key: { to_table: :users }, null: false
        t.references :updated_by, foreign_key: { to_table: :users }, null: false
        t.timestamps null: false
      end

      # rubocop:disable Rails/CreateTableWithTimestamps
      create_table(
        :letter_mailshot_items,
        comment: "A record of the letters sent in a mailshot"
      ) do |t|
        t.references :mailshot, foreign_key: { to_table: :letter_mailshot_mailshots }, null: false
        t.references :letter, foreign_key: { to_table: :letter_letters }, null: false
      end
      # rubocop:enable Rails/CreateTableWithTimestamps

      add_index(
        :letter_mailshot_items,
        [:mailshot_id, :letter_id],
        unique: true,
        comment: "A sanity check that a letter appears only once in a mailshot"
      )
    end
  end
end
