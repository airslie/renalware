# frozen_string_literal: true

module Renalware
  module Patients
    class MDMPatientsQuery
      include ModalityScopes
      include PatientPathologyScopes
      attr_reader :modality_names, :q, :relation

      # modality_names: eg "HD" or "PD"
      def initialize(relation: Patient.all, q:, modality_names:)
        @modality_names = modality_names
        @q = q
        @relation = relation
      end

      def call
        search.result
      end

      def search
        @search ||= begin
          relation
            .extending(ModalityScopes)
            .extending(PatientPathologyScopes)
            .with_current_pathology
            .with_current_modality_matching(modality_names)
            .ransack(q)
        end
      end
    end
  end
end
