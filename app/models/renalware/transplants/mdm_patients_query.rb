module Renalware
  module Transplants
    #  a list of everyone whose Modality is Transplant and the sort should
    #  be based on date of latest creatinine result descending (most recent
    #  at the top) - the default sort order should be same for all of the
    #  different filter groups
    class MDMPatientsQuery
      DEFAULT_SEARCH_PREDICATE = "cre_date DESC".freeze
      attr_reader :params, :relation, :named_filter

      def initialize(relation: Transplants::Patient.all, named_filter: nil, params: nil)
        @params = params || {}
        @params[:s] = DEFAULT_SEARCH_PREDICATE if @params[:s].blank?
        @relation = relation
        @named_filter = named_filter || :none
      end

      def call
        search.sorts = %w(given_name)
        search.result
      end

      def search
        @search ||= begin
          relation
            .include(ModalityScopes)
            .include(PatientPathologyScopes)
            .extending(NamedFilterScopes)
            .with_current_modality_of_class(Transplants::RecipientModalityDescription)
            .with_current_pathology
            .left_outer_joins(:current_observation_set)
            .public_send(named_filter.to_s)
            .ransack(params)
        end
      end

      module NamedFilterScopes
        def none
          self # NOOP
        end

        # rubocop:disable Rails/WhereRange
        def patients_with_a_transplant_date_in_the_past_3_months
          joins(<<-SQL.squish)
            LEFT JOIN transplant_recipient_operations
            ON patients.id = transplant_recipient_operations.patient_id
          SQL
            .where("transplant_recipient_operations.performed_on >= ?", 3.months.ago)
        end
        # rubocop:enable Rails/WhereRange
        alias recent patients_with_a_transplant_date_in_the_past_3_months

        def patients_on_the_worry_board
          joins("RIGHT OUTER JOIN patient_worries ON patient_worries.patient_id = patients.id")
        end
        alias on_worryboard patients_on_the_worry_board

        # rubocop:disable Rails/WhereRange
        def patients_with_a_transplant_operation_in_the_past_year
          joins(<<-SQL.squish)
            LEFT JOIN transplant_recipient_operations
            ON patients.id = transplant_recipient_operations.patient_id
          SQL
            .where("transplant_recipient_operations.performed_on >= ?", 1.year.ago)
        end
        # rubocop:enable Rails/WhereRange
        alias past_year patients_with_a_transplant_operation_in_the_past_year
      end
    end
  end
end
