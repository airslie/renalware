module Renalware
  module Clinical
    class AllergyStatusesController < BaseController
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::PatientVisibility

      def update
        authorize clinical_patient
        form = AllergyStatusForm.new(allergy_status_params)
        if form.save(clinical_patient, current_user)
          redirect_back fallback_location: patient_clinical_profile_path(clinical_patient),
                        notice: "Allergy status updated"
        else
          # we use client-side validation so will not get here
          raise NotImplementedError
        end
      end

      private

      def allergy_status_params
        params.require(:clinical_allergy_status_form).permit(:no_known_allergies)
      end
    end
  end
end
