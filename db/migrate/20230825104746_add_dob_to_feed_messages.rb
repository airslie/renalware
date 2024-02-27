class AddDobToFeedMessages < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    within_renalware_schema do
      add_column :feed_messages, :dob, :date, if_not_exists: true
    end
  end
end
