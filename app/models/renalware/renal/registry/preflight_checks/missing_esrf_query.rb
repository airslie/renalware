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
            search.result
          end

          def search
            relation
              .include(ModalityScopes)
              .include(QueryablePatient)
              .merge(HD::Patient.with_profile)
              .eager_load(:profile)
              .preload(current_modality: [:description])
              .with_current_modality_matching(MODALITY_NAMES)
              .where("renal_profiles.esrf_on IS NULL")
              .ransack(query_params)
          end

          module QueryablePatient
            extend ActiveSupport::Concern
            included do
              ransacker :hd_profile_unit_name, type: :string do
                Arel.sql("hospital_units.name")
              end

              ransacker :hd_profile_unit_id, type: :string do
                Arel.sql("hospital_units.id")
              end
            end
          end
        end
      end
    end
  end
end
