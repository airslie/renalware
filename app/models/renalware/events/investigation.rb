module Renalware
  module Events
    class Investigation < Event
      include Document::Base

      scope :transplant_donors, lambda {
        where("document ->> 'modality' = ?", "transplant_donor")
      }
      scope :transplant_recipients, lambda {
        where("document ->> 'modality' = ?", "transplant_recipient")
      }

      class Document < Document::Embedded
        attribute :modality,
                  ::Document::Enum,
                  enums: %i(transplant_donor transplant_recipient other)
        attribute :type, ::Document::Enum # See i18n for options
        attribute :result, String
        validates :modality, presence: true
        validates :type, presence: true
        validates :result, presence: true
      end
      has_document
    end
  end
end
