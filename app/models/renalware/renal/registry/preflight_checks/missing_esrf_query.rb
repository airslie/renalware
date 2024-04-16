# frozen_string_literal: true

module Renalware
  module Renal
    module Registry
      module PreflightChecks
        # Finds patients with a current modality of HD, PD or Transplant, who have no ESRF date
        class MissingESRFQuery
          MODALITY_NAMES = %w(HD PD Transplant).freeze

          attr_reader :relation, :query_params

          def self.missing_data_for(_patient)
            [
              :esrf
            ]
          end

          def initialize(relation: nil, query_params: {})
            @relation = relation || default_relation
            @query_params = query_params
            @query_params[:s] = "modality_descriptions_name ASC" if @query_params[:s].blank?
          end

          def default_relation
            Renalware::Renal::Patient.left_outer_joins(:profile)
          end

          def call
            search
              .result
              .include(ModalityScopes)
              .preload(current_modality: [:description])
              .merge(HD::Patient.with_profile)
              .eager_load(:profile)
              .with_current_modality_matching(MODALITY_NAMES)
              .where("renal_profiles.esrf_on IS NULL")
          end

          def search
            @search ||= relation.ransack(query_params)
          end
        end
      end
    end
  end
end
