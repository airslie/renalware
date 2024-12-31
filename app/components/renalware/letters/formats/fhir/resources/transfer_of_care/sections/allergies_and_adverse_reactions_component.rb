module Renalware
  module Letters::Formats::FHIR::Resources::TransferOfCare::Sections
    class AllergiesAndAdverseReactionsComponent < SectionComponent
      def clinical_patient = Renalware::Clinical.cast_patient(patient)
      delegate :allergies, :allergy_status, to: :clinical_patient, allow_nil: true
    end
  end
end
