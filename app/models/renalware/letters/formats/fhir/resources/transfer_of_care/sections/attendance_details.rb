module Renalware::Letters
  module Formats::FHIR::Resources::TransferOfCare
    class Sections::AttendanceDetails < Sections::Base
      def title = "Attendance details"
      def snomed_code = "1077881000000105"
    end
  end
end
