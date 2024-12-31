module Renalware
  module Events
    class AdvancedCarePlan < Events::Event
      include Document::Base

      class Document < Document::Embedded
        attribute :state, ::Document::Enum # See i18n for options
        validates :state, presence: true
      end
      has_document

      def partial_for(partial_type)
        File.join("renalware/events/advanced_care_plans", partial_type)
      end
    end
  end
end
