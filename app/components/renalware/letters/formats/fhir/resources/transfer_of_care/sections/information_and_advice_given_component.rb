module Renalware
  module Letters::Formats::FHIR::Resources::TransferOfCare::Sections
    class InformationAndAdviceGivenComponent < SectionComponent
      def call
        tag.table(width: "100%") do
          tag.tbody do
            tag.tr do
              tag.td(colspan: "2", style: "width:100%") do
                concat "InformationAndAdviceGivenComponent"
              end
            end
          end
        end
      end
    end
  end
end
