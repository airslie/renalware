module Renalware
  module Feeds
    # Responsible for parsing a raw HL7 message as a string and creates a
    # message object.
    #
    class MessageParser
      def self.parse(*)
        new.parse(*)
      end

      def parse(message_string)
        lines = message_string.split("\n").join("\r").lines
        HL7Message.new(::HL7::Message.new(lines))
      end
    end
  end
end
