module Renalware::Letters
  module Formats::FHIR::Resources::TransferOfCare
    class Sections::ClinicalSummary < Sections::Base
      def snomed_code = "887181000000106"
      def title = "Clinical summary"
    end
  end
end
