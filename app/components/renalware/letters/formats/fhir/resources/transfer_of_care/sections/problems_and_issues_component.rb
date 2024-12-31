module Renalware
  module Letters::Formats::FHIR::Resources::TransferOfCare::Sections
    class ProblemsAndIssuesComponent < SectionComponent
      def call
        tag.table(width: "100%") do
          tag.tbody do
            tag.tr do
              tag.td(colspan: "2", style: "width:100%") do
                concat "ProblemsAndIssuesComponent"
              end
            end
          end
        end
      end
    end
  end
end
