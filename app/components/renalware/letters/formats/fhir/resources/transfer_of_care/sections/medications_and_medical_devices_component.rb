module Renalware
  module Letters::Formats::FHIR::Resources::TransferOfCare::Sections
    class MedicationsAndMedicalDevicesComponent < SectionComponent
      include ApplicationHelper

      def prescriptions
        Renalware::Medications::PrescriptionsPresenter.new(patient).prescriptions
      end
      delegate_missing_to :prescriptions
    end
  end
end
