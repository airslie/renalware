module Renalware
  module Letters::Formats::FHIR::Resources::TransferOfCare::Sections
    class DiagnosesComponent < SectionComponent
      def problems
        @problems ||= CollectionPresenter.new(patient.problems, Problems::ProblemPresenter)
      end
    end
  end
end
