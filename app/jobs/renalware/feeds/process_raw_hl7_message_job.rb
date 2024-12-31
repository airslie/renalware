module Renalware
  module Feeds
    class ProcessRawHL7MessageJob < ApplicationJob
      def perform(message:)
        Renalware::Feeds.message_processor.call(message)
      end
    end
  end
end
