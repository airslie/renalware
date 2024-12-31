module Renalware
  module Patients
    class MDMListQuery
      attr_reader :relation, :q, :modality

      def initialize(relation:, modality:, q: nil)
        @relation = relation
        @modality = modality
        @q = q || {}
      end

      def call
        search.result
      end

      def search
        @search ||= relation.extending(Scopes).with_current_modality(modality)
      end

      module Scopes
        def with_current_modality(modality)
          joins(:modality_descriptions)
            .where(modality_descriptions: { name: modality },
                   modality_modalities: { state: "current" })
        end
      end
    end
  end
end
