# frozen_string_literal: true

module Renalware::Letters
  module Formats::FHIR::Resources::TransferOfCare
    class Sections::SafetyAlerts < Sections::Base
      def snomed_code = "886931000000107"
      def title = "Safety alerts"
    end
  end
end
