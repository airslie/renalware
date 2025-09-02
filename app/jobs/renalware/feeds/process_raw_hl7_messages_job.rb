module Renalware
  module Feeds
    # Called at a regular intervals eg by good_job.cron to pick up records in the RawHL7Message
    # table, and process them into Feeds::Message
    # Process messages in FIFO order.
    class ProcessRawHL7MessagesJob < ApplicationJob
      # rubocop:disable Metrics/MethodLength
      def perform
        RawHL7Message
          .order(sent_at: :asc, created_at: :asc)
          .find_each(batch_size: 100) do |raw_message|
          # Will keep doing same ones over and over if there's a problem processing one
          # Not sure how to fix this?
          # How to move the one failure on and process the rest?
          begin
            0 / 0 if raw_message.body&.include?("DIVIDE_BY_ZERO") # Simulate an error for testing
            ProcessRawHL7MessageJob.perform_now(message: raw_message.body.tr("\r", "\n"))
          rescue StandardError => e
            RawHL7MessageError.create!(
              body: raw_message.body,
              sent_at: raw_message.sent_at,
              error_message: e.message,
              error_message_backtrace: e.backtrace.join("\n")
            )
          end
          raw_message.destroy
        end
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
