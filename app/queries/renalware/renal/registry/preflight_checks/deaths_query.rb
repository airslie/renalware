module Renalware
  module Renal
    module Registry
      module PreflightChecks
        class DeathsQuery
          attr_reader :relation, :query_params

          def self.missing_data_for(_patient)
            [
              :cause_of_death
            ]
          end

          def initialize(relation: nil, query_params: {})
            @relation = relation || default_relation
            @query_params = query_params
            @query_params[:s] = "modality_descriptions_name ASC" if @query_params[:s].blank?
          end

          def call
            search
              .result
              .eager_load(current_modality: [:description])
              .where(modality_descriptions: { type: Renalware::Deaths::ModalityDescription.name })
              .left_outer_joins(:profile).includes(:profile)
              .where("patients.first_cause_id is NULL AND renal_profiles.esrf_on IS NOT NULL")
          end

          # Ransack object is used by the controller, passed to the view to allow sorting/filtering
          # See eg registry_preflight_checks_controller.rb:63
          def search
            @search ||= relation.ransack(query_params)
          end

          private

          def default_relation = Renalware::Renal::Patient.all
        end
      end
    end
  end
end
