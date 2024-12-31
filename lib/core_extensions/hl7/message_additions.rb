require "ruby-hl7"

module CoreExtensions
  module HL7
    module MessageAdditions
      # rubocop:disable Style/ZeroLengthPredicate
      def to_s
        @segments.collect { |s| s if s.to_s.length > 0 }.join("\r")
      end
      # rubocop:enable Style/ZeroLengthPredicate
    end
  end
end

HL7::Message.prepend(CoreExtensions::HL7::MessageAdditions)
