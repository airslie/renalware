# frozen_string_literal: true

module Renalware
  module Patients
    class PatientSearch
      def self.call(params)
        Renalware::Patient
          .includes(:hospital_centre, current_modality: [:description])
          .ransack(params[:patient_search]).tap do |search|
            search.sorts = %w(family_name_case_insensitive given_name)
          end
      end
    end
  end
end
