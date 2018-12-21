# frozen_string_literal: true

require_dependency "renalware/admissions"

module Renalware
  module Admissions
    class ConsultQuery
      attr_reader :query

      def initialize(query = nil)
        @query = query || {}
        @query[:ended_on_null] ||= true
        @query[:s] ||= "hospital_ward_name"
      end

      def call
        search.result
      end

      # Note we *MUST* join onto patients for PatientsRansackHelper.identity_match to work.
      # It might be better to refactor PatientsRansackHelper so we can include where required
      # eg below using .extending(PatientsRansackHelper) rather than relying on it being in
      # included in the model file.
      # note that adding .includes(:created_by) here creates an ambigous column
      # 'family_name' error
      # rubocop:disable Metrics/MethodLength
      def search
        @search ||= begin
          Consult
            .extend(RansackScopes)
            .joins(:patient)
            .eager_load(patient: [current_modality: :description])
            .includes(
              :consult_site,
              :hospital_ward,
              :created_by,
              patient: { current_modality: :description }
            )
            .order(created_at: :desc)
            .ransack(query)
        end
      end
      # rubocop:enable Metrics/MethodLength

      module RansackScopes
        def self.extended(base)
          # Using a custom ransacker here in order to sort by modality description name
          # because using a predicate like  :patient_current_modality_description_name
          # results in an INNER JOIN onto modalities.
          base.ransacker :modality_desc do
            Arel.sql("modality_descriptions.name")
          end
        end
      end
    end
  end
end
