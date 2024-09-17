# frozen_string_literal: true

module Renalware::Letters
  module Formats::FHIR::Resources::TransferOfCare
    class Sections::FamilyHistory < Sections::Base
      def title = "Family history"
      def snomed_code = "887111000000104"
    end
  end
end
