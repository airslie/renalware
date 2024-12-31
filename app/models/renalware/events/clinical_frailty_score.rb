module Renalware
  module Events
    class ClinicalFrailtyScore < Events::Event
      include Document::Base

      class Document < Document::Embedded
        attribute :score, ::Document::Enum # See i18n for options
        validates :score, presence: true, numericality: true
      end
      has_document

      def partial_for(partial_type)
        File.join("renalware/events/clinical_frailty_score", partial_type)
      end
    end
  end
end
