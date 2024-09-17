# frozen_string_literal: true

module Renalware
  module Letters::Formats::FHIR::Resources::TransferOfCare::Sections
    class InvestigationResultsComponent < SectionComponent
      def groups
        return [] unless letter&.pathology_snapshot

        @groups ||= Letters::PathologyLayout
          .snapshot_results_keyed_by_date(letter.pathology_snapshot)
      end
    end
  end
end
