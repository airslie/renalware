# frozen_string_literal: true

require_dependency "renalware/low_clearance"

module Renalware
  module LowClearance
    class MDMPatientsQuery
      include ModalityScopes
      DEFAULT_SEARCH_PREDICATE = "hgb_date DESC"
      attr_reader :query, :relation, :named_filter

      def initialize(relation: LowClearance::Patient.all, query: nil, named_filter: nil)
        @query = query || {}
        @named_filter = named_filter || :none
        @query[:s] = DEFAULT_SEARCH_PREDICATE if @query[:s].blank?
        @relation = relation
      end

      def call
        search.result
      end

      # rubocop:disable Metrics/MethodLength
      def search
        @search ||= begin
          relation
            .extending(PatientTransplantScopes)
            .extending(PatientPathologyScopes)
            .extending(ModalityScopes)
            .extending(NamedFilterScopes)
            .with_registration_statuses
            .with_current_pathology
            .left_outer_joins(:current_observation_set)
            .with_current_modality_of_class(LowClearance::ModalityDescription)
            .public_send(named_filter.to_s)
            .ransack(query)
        end
      end
      # rubocop:enable Metrics/MethodLength

      module NamedFilterScopes
        def none
          self # NOOP
        end

        def supportive_care
          joins(:profile)
          .where("low_clearance_profiles.document ->> 'dialysis_plan' LIKE 'not_for_dial%'")
        end

        def on_worryboard
          joins("RIGHT OUTER JOIN patient_worries ON patient_worries.patient_id = patients.id")
        end

        def tx_candidates
          where("transplant_registration_status_descriptions.code not ilike '%permanent'")
        end

        def urea
          where("convert_to_float(values->'URE'->>'result') >= 30.0")
        end

        def hgb_low
          where("convert_to_float(values->'HGB'->>'result') < 100.0")
        end

        def hgb_high
          where("convert_to_float(values->'HGB'->>'result') > 130.0")
        end
      end
    end
  end
end
