# frozen_string_literal: true

module Renalware
  module HD
    module QueryablePatient
      extend ActiveSupport::Concern
      included do
        # Using a custom ransacker to be able to order by access plan create_at
        # becuase I believe using an implcit :access_plan_create_at in the sort_link
        # will not work because there is no belongs_to access_plan on HD::Patient
        # and even adding a custom join to access_plans as we do, Ransack will not resolve
        # :access_plans_created_at. Still this seens a reasonable solution.
        # We mix this module into HD::Patient at runtime.
        ransacker :access_plan_date, type: :date do
          Arel.sql("coalesce(access_plans.created_at, '1900-01-01'::timestamp)")
        end
      end
    end

    class MDMPatientsQuery
      include ModalityScopes
      include PatientPathologyScopes
      MODALITY_NAMES = "HD"
      DEFAULT_SEARCH_PREDICATE = "hgb_date desc"
      attr_reader :q

      def initialize(q:)
        @q = q || {}
        @q[:s] = DEFAULT_SEARCH_PREDICATE if @q[:s].blank?
      end

      def call
        search.result
      end

      # rubocop:disable Metrics/MethodLength
      def search
        @search ||= begin
          HD::Patient
            .include(QueryablePatient)
            .joins(
              "left outer join access_plans on access_plans.patient_id = patients.id "\
              "and access_plans.terminated_at is null"
            )
            .eager_load(hd_profile: [:hospital_unit])
            .extending(ModalityScopes)
            .extending(PatientPathologyScopes)
            .with_current_pathology
            .with_current_modality_matching(MODALITY_NAMES)
            .search(q)
        end
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
