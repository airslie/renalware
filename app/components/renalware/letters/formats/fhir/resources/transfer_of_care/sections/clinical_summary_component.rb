# frozen_string_literal: true

module Renalware
  module Letters::Formats::FHIR::Resources::TransferOfCare::Sections
    class ClinicalSummaryComponent < SectionComponent
      def call
        tag.table(width: "100%") do
          tag.tbody do
            tag.tr do
              tag.td(colspan: "2", style: "width:100%") do
                concat content_tag(:p, "test")
              end
            end
          end
        end
      end
    end
  end
end
