# frozen_string_literal: true

module Renalware::Letters
  module Formats::FHIR::Resources::TransferOfCare
    class Sections::PlanAndRequestedActions < Sections::Base
      def snomed_code = "887201000000105"
      def title = "Plan and requested actions"
    end
  end
end
