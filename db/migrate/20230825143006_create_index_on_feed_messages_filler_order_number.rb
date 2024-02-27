class CreateIndexOnFeedMessagesFillerOrderNumber < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  # Create an index for filler_order_number - this will not have been pre-populated beforehand
  # - there will be no data in the column as we have only just added it in a previous migration -
  # so should be quick to run, but using concurrently just in case.
  def change
    within_renalware_schema do
      add_index(
        :feed_messages,
        :orc_filler_order_number,
        algorithm: :concurrently,
        if_not_exists: true
      )
    end
  end
end
