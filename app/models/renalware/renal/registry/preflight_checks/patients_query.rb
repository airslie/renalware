module Renalware
  module Renal
    module Registry
      module PreflightChecks
        class PatientsQuery
          MODALITY_NAMES = %w(HD PD Transplant).freeze
          attr_reader :relation, :query_params

          # Putting this here for now so all incomplete data criteria is all in one place.
          # Build an array of symbols for all missing data identified by the above query
          # rubocop:disable Style/SafeNavigationChainLength
          def self.missing_data_for(patient)
            renal_profile = Renal.cast_patient(patient).profile
            missing = []
            missing << :ethnicity if patient.ethnicity_id.blank?
            missing << :prd if renal_profile&.prd_description_id.blank?
            missing << :first_seen_on if renal_profile&.first_seen_on.blank?
            if renal_profile&.document&.comorbidities&.ischaemic_heart_dis&.status.blank?
              missing << :comorbidities_at_esrf
            end
            missing
          end
          # rubocop:enable Style/SafeNavigationChainLength

          def initialize(relation: nil, query_params: {})
            @relation = relation || default_relation
            @query_params = query_params
            @query_params[:s] = "modality_descriptions_name ASC" if @query_params[:s].blank?
          end

          # The way I understand Ransack is that if you use a query like profile_esrf_gt
          # (that's the RenalProfile in this case as we are dealing with a Renal::Patient)
          # it will do the left out join itself onto renal_profiles.
          # At one point I did a manual join onto renal_profiles here like this
          # .joins("LEFT OUTER JOIN renal_profiles ON renal_profiles.patient_id = patients.id")
          # but that only worked when there was no search predicate passed; when you pass eg
          # profile_esrf_gt it joins onto renal_profiles again and you get a duplicate join.
          # However using left_outer_joins here somehow prevents a duplicate join;
          # one join onto renal_profiles is there whether there is a renal_profile_esrf_gt present
          # or not. However it ONLY works if you use left_outer_joins BEFORE calling .ransack
          # - calling it afterwards (in #call below) still results in a duplicate join IF
          # renal_profile_esrf_gt is present in the query.
          #
          # I have to say, ransack eats up a lot of time and presents a lot of cognitive friction.
          # Building a custom form object would have shaved an hour off the writing (mainly
          # debugging) of this code.
          #
          # Update: moved loading of profile to #call.
          # Having it in #default_relation leads to a duplicate alias if sorting on esrf for
          # instance. Having to use .eager_load(:profile) in #call. However this creates n+1
          # queries. Ransack again creating more confusion...
          def default_relation
            Renalware::Renal::Patient.all
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
              .where(where_conditions)
              .preload(current_modality: [:description])
              .with_current_modality_matching(MODALITY_NAMES)
              .ransack(query_params)
          end

          def where_conditions
            <<-SQL.squish
              (patients.ethnicity_id is NULL)
              OR
              (renal_profiles.id IS NULL)
              OR
              (renal_profiles.prd_description_id IS NULL)
              OR
              (renal_profiles.first_seen_on IS NULL)
              OR
              (renal_profiles.document #>> '{comorbidities,ischaemic_heart_dis,status}' is null)
            SQL
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
