class AddIndexesToFeedMessages < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  # Add a descending index on feed_messages.created_at to speed up finding chronologically ordered
  # pathology for a newly added patient. We replay messages we find. Note the DESC in the index
  # helps us when batch-finding results as PG can read from the ordered index without having to
  # to find all matches before limiting them. This works provided the NULL LAST/FIRST is the same
  # in the index as in the query; the default seems to be NULLS FIRST in both so should be fine.
  #
  # We have most likely created this index ahead of time (note the nonauto suffix) and
  # hence here we only create if not exists. Creating it can take > 30 mins so best done ahead of
  # time.
  #
  # We could use CONCURRENTLY to prevent the table being locked which will cause Mirth timeouts.
  # However with Mirth running and inserting on the table, and using CONCURRENTLY, I am not sure it
  # would ever finish... Better to not use CONCURRENTLY and pause Mirth - or remember to resubmit
  # failed jobs once the index is built.
  def up
    connection.execute(<<-SQL.squish)
      CREATE INDEX IF NOT EXISTS index_feed_messages_created_at_nonauto ON
        renalware.feed_messages
          USING BTREE (created_at DESC);
    SQL
  end

  def down
    connection.execute(<<-SQL.squish)
      DROP INDEX IF EXISTS index_feed_messages_created_at_nonauto;
    SQL
  end
end
