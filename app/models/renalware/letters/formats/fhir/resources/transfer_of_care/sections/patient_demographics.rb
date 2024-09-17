# frozen_string_literal: true

module Renalware::Letters
  module Formats::FHIR::Resources::TransferOfCare
    class Sections::PatientDemographics < Sections::Base
      def snomed_code = "886731000000109"
      def title = "Patient demographics"
      def entries = [{ reference: arguments.patient_urn }]
    end
  end
end
