module Renalware
  module EPR
    class MdtFilename < Filename
      private

      def document_name = "MDT_Meeting_Notes"
      def timestamp = document.created_at
      def document_type = Renalware.config.epr_mdt_document_type
    end
  end
end
