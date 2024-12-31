module Renalware
  module Feeds
    class ProcessFeedMessagesJob < ApplicationJob
      # A good-job-cron-scheduled job that looks for rows in feed_sausage_queue, where each row is
      # an imperative to create a new background job to process (import) the specified feed_sausage.
      # We use a separate table for these instructions to avoid querying the very large
      # feed_sausages table.
      # Note that if for instance ActiveJob is paused, the items in the SausageQueue will build up
      # and its is possible that we might have two rows referencing the same sausage. This is
      # because a partial ORU for with ORC FON '123' might arrive, followed a few hours later by
      # say a final message with the same ORU. The second message updates the sausage created by
      # the first, but both add a distinct entry into SausageQueue. Since both entries in the
      # point to the same (updated) Sausage, then we can safely only process one of them and
      # ignore the other, hence the processed_sausage_ids below which tracks already-imported
      # feed_sausage_ids
      def perform
        processed_sausage_ids = []
        SausageQueue.find_each do |queue_item|
          # We use a Tx around the two database operations as we do not want to delete the
          # queue item unless we are sure we have added a background job
          SausageQueue.transaction do
            unless processed_sausage_ids.include?(queue_item.feed_sausage_id)
              ProcessFeedMessageJob.perform_later(sausage_id: queue_item.feed_sausage_id)
              processed_sausage_ids << queue_item.feed_sausage_id
            end
            queue_item.destroy!
          end
        end
      end
    end
  end
end
