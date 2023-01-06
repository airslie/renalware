# frozen_string_literal: true

# TODO: code here bleeds across modules

module Renalware
  module HD
    class MDMPatientsQuery
      include ModalityScopes
      include PatientPathologyScopes
      DEFAULT_SEARCH_PREDICATE = "hgb_date desc"
      attr_reader :params, :named_filter, :relation

      def initialize(params:, named_filter:, relation: HD::Patient.all)
        @params = params || {}
        @params[:s] = DEFAULT_SEARCH_PREDICATE if @params[:s].blank?
        @named_filter = named_filter || :none
        @relation = relation
      end

      def call
        search.result
      end

      # rubocop:disable Metrics/MethodLength
      def search
        @search ||= begin
          relation
            .include(QueryablePatient)
            .extending(PatientTransplantScopes)
            .merge(Accesses::Patient.with_current_plan)
            .merge(Accesses::Patient.with_profile)
            .eager_load(hd_profile: [:hospital_unit])
            .extending(ModalityScopes)
            .extending(PatientPathologyScopes)
            .extending(NamedFilterScopes)
            .with_current_pathology
            .with_registration_statuses
            .with_current_modality_of_class(Renalware::HD::ModalityDescription)
            .public_send(named_filter.to_s)
            .ransack(params)
        end
      end
      # rubocop:enable Metrics/MethodLength

      # Module to allow us to mixin ransackers
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

          ransacker :access_plan_type, type: :string do
            Arel.sql("coalesce(access_plan_types.name, '')")
          end

          ransacker :current_access, type: :string do
            Arel.sql("access_types.name")
          end
        end
      end
    end

    # Module to allow us to mixin named filters like on_worryboard which correspond to tabs
    # on the UI for example.
    module NamedFilterScopes
      def none
        self # NOOP - aka 'all'
      end

      def patients_on_the_worry_board
        joins("RIGHT OUTER JOIN patient_worries ON patient_worries.patient_id = patients.id")
      end
      alias_method :on_worryboard, :patients_on_the_worry_board
    end
  end
end
