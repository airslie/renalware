module Renalware
  module Letters::Transports::Mesh
    class CheckInboxJob < ApplicationJob
      include GoodJob::ActiveJobExtensions::Batches

      queue_as :mesh
      queue_with_priority 10

      MAX_MESSAGE_TRANCH_SIZE = 500

      class BatchCallbackJob < ApplicationJob
        # Callback jobs must accept a `batch` and `context` argument
        def perform(batch, _context)
          GoodJob.logger.warn "BULK This is a callback from GoodJob batch #{batch&.id}"
          GoodJob.logger.warn "BULK Enqueuing CheckInboxJob to check for more messages."
          CheckInboxJob.perform_later
        end
      end

      # Can do async or sync processing of messages.
      def perform = perform_async

      def perform_async # rubocop:disable Metrics/MethodLength
        GoodJob.logger.warn "BULK Performing CheckInboxJob"
        message_ids = fetch_waiting_messages
        GoodJob.logger.warn "BULK #{message_ids&.size} messages waiting in MESH inbox."

        if message_ids.any?
          # Messages are fetched from the MESH inbox in tranches of MAX_MESSAGE_TRANCH_SIZE (500)
          # If we get exactly MAX_MESSAGE_TRANCH_SIZE messages then we know there are more messages
          # and we keep polling until the inbox is empty.
          if message_ids.size == MAX_MESSAGE_TRANCH_SIZE
            GoodJob.logger.warn "BULK Batch enqueuing #{message_ids.size} MESH messages."
            GoodJob::Batch.enqueue(on_finish: BatchCallbackJob) do
              enqueue_download_message_jobs(message_ids)
            end
          else
            enqueue_download_message_jobs(message_ids)
          end
        end
      end

      # A single-threaded version of the job that does not spawn async DownloadMessageJob jobs.
      def perform_sync
        # Messages are fetched from the MESH inbox in tranches of MAX_MESSAGE_TRANCH_SIZE (500)
        # If we get exactly MAX_MESSAGE_TRANCH_SIZE messages then we know there are more messages
        # and we keep polling until the inbox is empty.
        message_ids = fetch_waiting_messages
        GoodJob.logger.warn "BULK #{message_ids&.size} messages waiting in MESH inbox."
        loop until message_ids.empty? do
          message_ids.each { |message_id| DownloadMessageJob.perform_now(message_id) }
          if message_ids.size == MAX_MESSAGE_TRANCH_SIZE
            message_ids = fetch_waiting_messages
          end
        end
      end

      private

      def enqueue_download_message_jobs(message_ids)
        message_ids.each do |message_id|
          GoodJob.logger.warn "BULK Enqueuing DownloadMessageJob for MESH message ID: #{message_id}"
          DownloadMessageJob.perform_later(message_id)
        end
      end

      def fetch_waiting_messages
        response = API::LogOperation.new(:check_inbox).call { API::Client.check_inbox }

        unless response.body["messages"].is_a?(Array)
          raise "No messages array found in MESH inbox JSON"
        end

        response.body["messages"]
      end
    end
  end
end
