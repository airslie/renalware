class AddResultThreadKeyToFeedMessages < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      safety_assured do
        # Note: Adding the column and index should be quick operations despite the table size
        comment = <<~COMMENT
          A key to identify messages that are part of the same result thread, where the result thread
          is _basically_ ORC placer order number, but we prefix it with the sending app identifier
          from MSH-4, and suffix it with the fist OBR observation request identifier (OBR-4).
          ie LAB1:123445:UE
          The reasoning behind is that we need to be able to group the 'same' OUR^R01 message as it
          progresses through its states (orc order status A -> IP -> CM) so we can remove all but the
          final CM message (there can be >1 CM) in a housekeeping SQL function.
          We cannot use ORC filler order number for this as it spans multiple messages. So we
          use placer order number which is unique per OBR, but pre-and suffix it as above to
          guarantee uniqueness.
        COMMENT
        add_column :feed_messages, :result_thread_key, :string, comment: comment, if_not_exists: true
        add_index :feed_messages, :result_thread_key, if_not_exists: true
      end
    end
  end
end
