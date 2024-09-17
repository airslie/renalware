# frozen_string_literal: true

module Renalware::Letters
  module Formats::FHIR::Resources::TransferOfCare
    class Sections::ReferrerDetails < Sections::Base
      def snomed_code = "1052891000000108"
      def title = "Referrer details"
    end
  end
end
