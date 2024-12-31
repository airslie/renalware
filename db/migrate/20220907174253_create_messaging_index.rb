class CreateMessagingIndex < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    within_renalware_schema do
      add_index(
        :messaging_receipts,
        :recipient_id,
        name: :idx_unread_messaging_receipts,
        where: "read_at is null",
        algorithm: :concurrently
      )
    end
  end
end
