class AddTypeToMessagingMessages < ActiveRecord::Migration[5.1]
  def up
    add_column :messaging_messages, :type, :string, null: true
    add_index :messaging_messages, :type
    connection.execute(
      "update messaging_messages set type = 'Renalware::Messaging::Internal::Message' where type is null;"
    )
    change_column_null(:messaging_messages, :type, false)
  end

  def down
    remove_index :messaging_messages, :type
    remove_column :messaging_messages, :type
  end
end
