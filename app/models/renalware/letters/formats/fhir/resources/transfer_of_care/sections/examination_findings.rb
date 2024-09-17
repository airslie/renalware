# frozen_string_literal: true

module Renalware::Letters
  module Formats::FHIR::Resources::TransferOfCare
    class Sections::ExaminationFindings < Sections::Base
      def title = "Examination findings"
      def snomed_code = "715851000000102"
    end
  end
end
