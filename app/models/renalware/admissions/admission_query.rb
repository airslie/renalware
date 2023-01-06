# frozen_string_literal: true

module Renalware
  module Admissions
    class AdmissionQuery
      pattr_initialize :query

      def self.call(query)
        new(query).call
      end

      def call
        search.result
      end

      def search
        @search ||= begin
          Admission
            .extending(Scopes)
            .joins(:patient) # required for PatientsRansackHelper - see Admission
            .includes(
              hospital_ward: [:hospital_unit],
              patient: { current_modality: [:description] }
            )
            .order(created_at: :desc)
            .ransack(query)
        end
      end

      module Scopes
        def ransackable_scopes(_auth_object = nil)
          %i(currently_admitted discharged_but_missing_a_summary identity_match)
        end
      end
    end
  end
end
