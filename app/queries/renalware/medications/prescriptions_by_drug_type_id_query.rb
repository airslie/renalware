module Renalware
  module Medications
    class PrescriptionsByDrugTypeIdQuery
      pattr_initialize [:drug_type_id!, :patient!, provider: nil]

      def call
        results = patient
          .prescriptions
          .current
          .includes(:medication_route, :drug)
          .includes(patient: { current_modality: :description })
          .eager_load(drug: [:drug_types])
          .where("drug_types.id": drug_type_id)

        provider.present? ? results.where(provider: provider) : results
      end
    end
  end
end
