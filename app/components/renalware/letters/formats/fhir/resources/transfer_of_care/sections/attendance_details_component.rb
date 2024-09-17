# frozen_string_literal: true

module Renalware
  module Letters::Formats::FHIR::Resources::TransferOfCare::Sections
    class AttendanceDetailsComponent < SectionComponent
      def call
        tag.table(width: "100%") do
          tag.tbody do
            tag.tr do
              tag.td(colspan: "2", style: "width:100%") do
                concat letter.salutation
                concat tag.br
                concat letter.body
              end
            end
          end
        end
      end
    end
  end
end
