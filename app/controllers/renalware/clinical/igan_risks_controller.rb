require "collection_presenter"

module Renalware
  module Clinical
    class IganRisksController < BaseController
      include Renalware::Concerns::PatientCasting

      def edit
        igan_risk = clinical_patient.igan_risk || clinical_patient.build_igan_risk
        authorize igan_risk
        render_edit(igan_risk)
      end

      def update
        igan_risk = clinical_patient.igan_risk || clinical_patient.build_igan_risk
        authorize igan_risk
        if igan_risk.update_by(current_user, igan_params)
          redirect_to patient_clinical_profile_path(clinical_patient)
        else
          render_edit(igan_risk)
        end
      end

      private

      def render_edit(igan_risk)
        render :edit, locals: { igan_risk: igan_risk }
      end

      def igan_params
        params.require(:igan_risk).permit(:risk, :workings)
      end
    end
  end
end
