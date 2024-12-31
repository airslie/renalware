require "month_period"

module Renalware
  module Pathology
    class ReprocessFeedMessageJob < ApplicationJob
      self.log_arguments = false

      def perform(message:)
        message.touch
        Ingestion::MessageListener.new.oru_message_arrived(
          hl7_message: Feeds::MessageParser.parse(message.body),
          feed_message: message
        )
      end
    end
  end
end
