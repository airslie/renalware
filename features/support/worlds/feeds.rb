module World
  module Feeds
    module Domain
      def parse_message(raw_message)
        Renalware::Feeds::MessageParser.parse(raw_message)
      end

      def process_message(raw_message)
        Renalware::Feeds.message_processor.call(raw_message)
      end

      def expect_message_to_be_recorded(message)
        message_record = Renalware::Feeds::Message.find_by(
          message_type: message.message_type,
          event_type: message.event_type
        )
        expect(message_record).to be_present
      end
    end
  end
end
