module Renalware
  module Events
    class Biopsy < Event
      include Document::Base

      class Document < Document::Embedded
        attribute :result1, ::Document::Enum # See i18n for options
        attribute :result2, ::Document::Enum # See i18n for options
      end
      has_document
    end
  end
end
