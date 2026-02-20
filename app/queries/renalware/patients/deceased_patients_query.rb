module Renalware
  module Patients
    # Finds patients with a death modality or who have a died_on date
    class DeceasedPatientsQuery
      attr_reader :query_params, :scope

      def initialize(query_params, scope: Patient)
        @scope = scope
        @query_params = query_params || {}
        @query_params[:s] = "family_name ASC" if @query_params[:s].blank?
      end

      def call
        search.result.where(id: ids_of_deceased_patients)
      end

      def search
        scope
          .includes(:first_cause, current_modality: :description)
          .ransack(query_params)
      end

      private

      def ids_of_deceased_patients
        (ids_of_patients_with_death_modality + ids_of_patients_with_died_on_date).uniq
      end

      def ids_of_patients_with_death_modality
        Patient
          .include(ModalityScopes)
          .with_current_modality_of_class(Renalware::Deaths::ModalityDescription)
          .pluck(:id)
      end

      def ids_of_patients_with_died_on_date
        Patient.where.not(died_on: nil).pluck(:id)
      end
    end
  end
end
