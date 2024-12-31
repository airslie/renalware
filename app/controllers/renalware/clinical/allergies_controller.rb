module Renalware
  module Clinical
    class AllergiesController < BaseController
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::PatientVisibility

      def create
        result = CreateAllergy.new(clinical_patient, current_user).call(allergy_params) do |allergy|
          authorize allergy
        end
        if result.success?
          redirect_back fallback_location: patient_clinical_profile_path(clinical_patient),
                        notice: success_msg_for("allergy")

        else
          # we use client-side validation so will not get here
          raise NotImplementedError
        end
      end

      def destroy
        allergy = clinical_patient.allergies.find(params[:id])
        authorize allergy
        DeleteAllergy.new(allergy, current_user).call
        redirect_back fallback_location: patient_clinical_profile_path(clinical_patient),
                      notice: t("destroy.success_with_name", name: allergy.description)
      end

      private

      def allergy_params
        params.require(:clinical_allergy).permit([:description])
      end
    end
  end
end
