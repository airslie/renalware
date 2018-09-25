# frozen_string_literal: true

module Renalware
  module PD
    class MDMPatientsQuery
      include ModalityScopes
      include PatientPathologyScopes
      MODALITY_NAMES = "PD"
      DEFAULT_SEARCH_PREDICATE = "hgb_date desc"
      attr_reader :q, :relation

      def initialize(relation: PD::Patient.all, q:)
        @q = q || {}
        @q[:s] = DEFAULT_SEARCH_PREDICATE if @q[:s].blank?
        @relation = relation
      end

      def call
        search.result
      end

      def search
        @search ||= begin
          relation
            .extending(PatientTransplantScopes)
            .extending(ModalityScopes)
            .extending(PatientPathologyScopes)
            .with_current_modality_matching(MODALITY_NAMES)
            .with_current_pathology
            .with_registration_statuses
            .left_outer_joins(:current_observation_set)
            .search(q)
        end
      end
    end
  end
end
