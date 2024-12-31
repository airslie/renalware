module Renalware
  module Feeds
    module_function

    def table_name_prefix = "feed_"

    class DuplicateMessageError < StandardError; end

    def message_processor
      @message_processor ||= build_message_processor
    end

    def build_message_processor
      MessageProcessor.new.broadcasting_to_configured_subscribers
    end
  end
end
