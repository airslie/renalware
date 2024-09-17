# frozen_string_literal: true

module Renalware
  module Letters::Transports::Mesh
    class CheckInboxJob < ApplicationJob
      queue_as :mesh
      queue_with_priority 10

      MAX_MESSAGE_TRANCH_SIZE = 500

      def perform
        response = fetch_ids_of_inbox_messages_to_download
        message_ids = response.body["messages"]
        if message_ids.length == MAX_MESSAGE_TRANCH_SIZE
          enqueue_download_jobs_using_a_batch_and_callback_job(messages_ids)
        else
          enqueue_download_jobs(message_ids)
        end
      end

      private

      def fetch_ids_of_inbox_messages_to_download
        API::LogOperation.new(:check_inbox).call do |_operation|
          API::Client.check_inbox
        end
      end

      def enqueue_download_jobs(messages)
        messages.each do |message_id|
          DownloadMessageJob.perform_later(message_id)
        end
      end

      # As there are at least MAX_MESSAGE_TRANCH_SIZE messages in the inbox, use the GoodJob::Batch
      # feature to fetch the first MAX_MESSAGE_TRANCH_SIZE messages we know about asynchronously,
      # and then once those jobs have finished, enqueue another CheckInboxJob to get the next tranch
      # of messages.
      def enqueue_download_jobs_using_a_batch_and_callback_job(messages)
        batch = GoodJob::Batch.add do
          messages.each do |message_id|
            DownloadMessageJob.perform_later(message_id)
          end
        end
        batch.enqueue(on_finish: CheckInboxJob)
      end
    end
  end
end
