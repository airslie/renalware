class AddMoreIndexesToFeedMessages < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    within_renalware_schema do
      add_index :feed_messages, :sent_at, if_not_exists: true, algorithm: :concurrently
      add_index :feed_messages, :dob, if_not_exists: true, algorithm: :concurrently
    end
  end
end
