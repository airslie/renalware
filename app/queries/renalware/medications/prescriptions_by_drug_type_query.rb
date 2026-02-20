module Renalware
  module Medications
    class PrescriptionsByDrugTypeQuery
      attr_reader :drug_type_name, :search_params

      def initialize(drug_type_name:, search_params: nil)
        @drug_type_name = drug_type_name.downcase
        @search_params = search_params || {}
        @search_params.reverse_merge!(s: Prescription.default_search_order)
      end

      def call
        search.result
      end

      def search
        @search ||= Prescription
          .current
          .includes(:medication_route, :drug)
          .includes(patient: { current_modality: :description })
          .eager_load(drug: [:drug_types])
          .where("lower(drug_types.name) = lower(?)", drug_type_name)
          .ransack(search_params)
      end
    end
  end
end
