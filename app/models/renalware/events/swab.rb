module Renalware
  module Events
    class Swab < Event
      include Document::Base

      class Document < Document::Embedded
        attribute :type, ::Document::Enum, enums: %i(mrsa mssa)
        attribute :result, ::Document::Enum, enums: %i(pos neg)
        attribute :location, String
        validates :type, presence: true
      end
      has_document
    end
  end
end
