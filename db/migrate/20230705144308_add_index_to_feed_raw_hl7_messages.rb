class AddIndexToFeedRawHL7Messages < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      safety_assured do
        comment = <<~COMMENT.squish
          We query for rows ordering by created_at asc to give us a chance to process in FIFO order,
          so having an ordered index means when we use a LIMIT (batching) in the query, rows will
          be determined by index scan without having to look to the end of the table -
          or something like that! In fact the index is implicitly ordered already but having
          created_at: :asc here makes our intention more explicit.
        COMMENT
        # E.g.
        # SELECT * FROM "feed_raw_hl7_messages" ORDER BY created_at desc LIMIT 100;
        # => -> Index Scan using
        #   index_feed_raw_hl7_messages_on_created_at on renalware.feed_raw_hl7_messages
        #   cost=0.12..2.34 rows=1 width=56) (actual time=0.014..0.015 rows=0 loops=1)
        add_index(
          :feed_raw_hl7_messages,
          :created_at,
          order: { created_at: :asc },
          comment: comment,
          if_not_exists: true
        )
      end
    end
  end
end
