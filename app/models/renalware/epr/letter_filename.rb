module Renalware
  module EPR
    class LetterFilename < Filename
      private

      def document_name = "Renal_Outpatient_Letter"
      def timestamp = document.approved_at
      def document_type = Renalware.config.epr_letter_document_type
    end
  end
end
