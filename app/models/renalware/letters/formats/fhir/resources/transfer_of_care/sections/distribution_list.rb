module Renalware::Letters
  module Formats::FHIR::Resources::TransferOfCare
    class Sections::DistributionList < Sections::Base
      def snomed_code = "887261000000109"
      def title = "Distribution list"

      # TODO: build recipients list here
      def entries
        [
          #   # Reference to the practitioner entries as recipients of information
          #   {
          #     reference: "urn:uuid:5ca24866-f34e-43d5-9d4a-c661beb9b5ae" # TODO
          #   },
          # Reference to the patient entry as recipient of information
          {
            reference: arguments.patient_urn
          }
        ]
      end
    end
  end
end
