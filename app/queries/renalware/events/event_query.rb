module Renalware
  module Events
    class EventQuery
      attr_reader :query, :patient

      def initialize(patient:, query: {})
        @query = query
        @patient = patient
        set_default_sort_order_if_none_specified
      end

      def set_default_sort_order_if_none_specified
        @query[:s] = "date_time DESC" if @query[:s].blank?
      end

      def call
        search
          .result
          .for_patient(patient)
          .includes(:patient)
          .eager_load(:patient)
          .includes(:event_type)
          .eager_load(:event_type)
          .includes(:created_by)
          .eager_load(:created_by)
          .ordered
      end

      def search
        @search ||= Event.ransack(query)
      end
    end
  end
end
