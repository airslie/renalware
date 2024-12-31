# Decorates an a Clinical::Patient so we can access patient.allergies in the view
module Renalware
  module Letters
    class Part::Allergies < Section
      attr_reader :allergy_status, :patient

      delegate_missing_to :allergies
      delegate :allergy_status, to: :clinical_patient
      delegate :allergies, to: :clinical_patient

      def to_partial_path
        "renalware/letters/parts/allergies"
      end

      def clinical_patient
        ::Renalware::Clinical.cast_patient(patient)
      end
    end
  end
end
