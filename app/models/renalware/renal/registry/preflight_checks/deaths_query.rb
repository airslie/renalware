# frozen_string_literal: true

module Renalware
  module Renal
    module Registry
      module PreflightChecks
        class DeathsQuery
          include ModalityScopes

          attr_reader :relation, :query_params

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
              .extending(ModalityScopes)
              .preload(current_modality: [:description])
              .with_current_modality_of_class(Renalware::Deaths::ModalityDescription)
              .where("patients.first_cause_id is NULL AND renal_profiles.esrf_on IS NOT NULL")
          end

          def search
            @search ||= relation.ransack(query_params)
          end

          def self.missing_data_for(_patient)
            [
              :cause_of_death
            ]
          end
        end
      end
    end
  end
end
