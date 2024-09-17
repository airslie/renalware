# frozen_string_literal: true

module Renalware::Letters
  module Formats::FHIR::Resources::TransferOfCare
    class Sections::InvestigationResults < Sections::Base
      def snomed_code = "1082101000000102"
      def title = "Investigation results"
    end
  end
end
