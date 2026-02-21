module Renalware
  module Patients
    class WorryQuery
      attr_reader :query_params, :patient_scope

      def initialize(query_params:, patient_scope: Patient.all)
        @query_params = query_params
        @query_params[:s] = "date_time DESC" if @query_params[:s].blank?
        @patient_scope = patient_scope
      end

      def call
        search
          .result
          .eager_load(:patient)
          .includes(:created_by, patient: { current_modality: [:description] })
          .order(created_at: :asc)
      end

      def search
        @search ||= Worry
          .eager_load(:patient, :worry_category)
          .joins(:patient)
          .merge(patient_scope)
          .ransack(query_params)
      end
    end
  end
end
