module Renalware
  module Patients
    class MDMPatientsQuery
      attr_reader :modality_names, :q, :relation

      # modality_names: eg "HD" or "PD"
      def initialize(q:, modality_names:, relation: Patient.all)
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
            .include(ModalityScopes)
            .include(PatientPathologyScopes)
            .with_current_pathology
            .with_current_modality_matching(modality_names)
            .ransack(q)
        end
      end
    end
  end
end
