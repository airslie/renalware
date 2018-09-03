# frozen_string_literal: true

require_dependency "renalware/patients"

module Renalware
  module Patients
    class WorryQuery
      attr_reader :query_params

      def initialize(query_params)
        @query_params = query_params
        @query_params[:s] = "date_time DESC" if @query_params[:s].blank?
      end

      def call
        search
          .result
          .includes(:created_by, patient: { current_modality: [:description] })
          .order(created_at: :asc)
      end

      def search
        @search ||= Worry.ransack(query_params)
      end
    end
  end
end
