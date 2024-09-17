# frozen_string_literal: true

module Renalware::Letters
  module Formats::FHIR::Resources::TransferOfCare
    class Sections::AllergiesAndAdverseReactions < Sections::Base
      def snomed_code = "886921000000105"
      def title = "Allergies and adverse reactions"
    end
  end
end
