# frozen_string_literal: true

module Renalware::Letters
  module Formats::FHIR::Resources::TransferOfCare
    class Sections::LegalInformation < Sections::Base
      def snomed_code = "886961000000102"
      def title = "Legal information"
    end
  end
end
