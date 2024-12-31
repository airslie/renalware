module Renalware
  module Transplants
    # Extends a RecipientWorkupDocument::YesNoUnknownConsent document attribute
    class ConsentPresenter < SimpleDelegator
      # Renders eg "12-Apr-2018 Yes"
      def to_s
        [I18n.l(consented_on), value&.text].compact.join(" ")
      end
    end
  end
end
