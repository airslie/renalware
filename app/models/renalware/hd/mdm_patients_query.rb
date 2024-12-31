# TODO: code here bleeds across modules

module Renalware
  module HD
    class MDMPatientsQuery
      DEFAULT_SEARCH_PREDICATE = "hgb_date desc".freeze
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

      def search
        @search ||= relation
          .include(QueryablePatient)
          .include(PatientTransplantScopes)
          .include(PatientPathologyScopes)
          .include(ModalityScopes)
          .extending(NamedFilterScopes)
          .merge(Accesses::Patient.with_current_plan)
          .merge(Accesses::Patient.with_profile)
          .eager_load(hd_profile: [:hospital_unit])
          .with_current_pathology
          .with_registration_statuses
          .with_current_modality_of_class(Renalware::HD::ModalityDescription)
          .public_send(named_filter.to_s)
          .ransack(params)
      end

      # Module to allow us to mixin ransackers
      module QueryablePatient
        extend ActiveSupport::Concern
        included do
          # Using a custom ransacker to be able to order by access plan create_at
          # because I believe using an implicit :access_plan_create_at in the sort_link
          # will not work because there is no belongs_to access_plan on HD::Patient
          # and even adding a custom join to access_plans as we do, Ransack will not resolve
          # :access_plans_created_at. Still this seems a reasonable solution.
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

        class_methods do
          # Make sure we whitelist the ransackers defined above
          def ransackable_attributes(*) = super + _ransackers.keys
        end
      end
    end

    # Module to allow us to mixin named filters like on_worryboard which correspond to tabs
    # on the UI for example.
    module NamedFilterScopes
      def none
        self # NOOP
      end

      def patients_on_the_worry_board
        joins("RIGHT OUTER JOIN patient_worries ON patient_worries.patient_id = patients.id")
      end
      alias on_worryboard patients_on_the_worry_board
    end
  end
end
