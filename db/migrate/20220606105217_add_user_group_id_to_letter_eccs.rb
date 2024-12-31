class AddUserGroupIdToLetterEccs < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    within_renalware_schema do
      add_reference(
        :letter_electronic_receipts,
        :user_group,
        references: :user_groups,
        index: { algorithm: :concurrently },
        null: true,
        comment: "If the user chose a user group as a the eCC recipient " \
                 "(rather than a user) then we split up the group and store " \
                 "each member as a row, but assign the letter_group_id for reference"
      )

      add_foreign_key(
        :letter_electronic_receipts,
        :user_groups,
        validate: false
      )
    end
  end
end
