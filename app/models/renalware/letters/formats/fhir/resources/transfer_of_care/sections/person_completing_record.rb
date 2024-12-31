module Renalware::Letters
  module Formats::FHIR::Resources::TransferOfCare
    class Sections::PersonCompletingRecord < Sections::Base
      def snomed_code = "887231000000104"
      def title = "Person completing record"
      def entries = [{ reference: arguments.author_urn }]
    end
  end
end
