# frozen_string_literal: true

module Renalware::Letters
  module Formats::FHIR::Resources::TransferOfCare
    class Sections::ClinicalReviewOfSystems < Sections::Base
      def snomed_code = "1077901000000108"
      def title = "Clinical review of systems"
    end
  end
end
