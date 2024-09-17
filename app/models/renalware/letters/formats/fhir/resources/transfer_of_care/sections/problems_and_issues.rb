# frozen_string_literal: true

module Renalware::Letters
  module Formats::FHIR::Resources::TransferOfCare
    class Sections::ProblemsAndIssues < Sections::Base
      def snomed_code = "887151000000100"
      def title = "Problems and issues"
      def entries = [{ reference: arguments.patient_urn }]
    end
  end
end
