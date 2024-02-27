class AddOrcOrderStatusToFeedMessages < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    within_renalware_schema do
      # A Some, but not all, results available
      # CA  Order was canceled
      # CM  Order is completed
      # DC  Order was discontinued
      # ER  Error, order not found
      # HD  Order is on hold
      # IP  In process, unspecified
      # RP  Order has been replaced
      # SC In process, scheduled
      create_enum :enum_hl7_orc_order_status, %w(A CA CM DC ER HD IP RP SC), if_not_exists: true

      add_column(
        :feed_messages,
        :orc_order_status, :enum,
        enum_type: :enum_hl7_orc_order_status,
        if_not_exists: true
      )
    end
  end
end
