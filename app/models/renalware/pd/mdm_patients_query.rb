module Renalware
  module PD
    class MDMPatientsQuery
      DEFAULT_SEARCH_PREDICATE = "hgb_date desc".freeze
      attr_reader :params, :relation, :named_filter

      def initialize(params:, relation: PD::Patient.all, named_filter: nil)
        @params = params || {}
        @params[:s] = DEFAULT_SEARCH_PREDICATE if @params[:s].blank?
        @relation = relation
        @named_filter = named_filter || :none
      end

      def call
        search.result
      end

      def search
        @search ||= begin
          relation
            .include(PatientTransplantScopes)
            .include(ModalityScopes)
            .include(PatientPathologyScopes)
            .extending(NamedFilterScopes)
            .with_current_modality_of_class(Renalware::PD::ModalityDescription)
            .with_current_pathology
            .with_registration_statuses
            .left_outer_joins(:current_observation_set)
            .public_send(named_filter.to_s)
            .ransack(params)
        end
      end
    end

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
