module Renalware
  module Letters::Formats::FHIR::Resources::TransferOfCare::Sections
    class SectionPreviewComponent < ViewComponent::Preview
      def with_letter_id(letter_id: nil)
        letter = if letter_id.present?
                   Renalware::Letters::Letter.find(letter_id)
                 else
                   Renalware::Letters::Letter.last
                 end
        klass = Object.const_get(self.class.name.sub("Preview", ""))
        render(klass.new(letter))
      end
    end
  end
end
