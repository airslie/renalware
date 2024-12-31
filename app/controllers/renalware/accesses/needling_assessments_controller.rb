require "collection_presenter"

module Renalware
  module Accesses
    class NeedlingAssessmentsController < BaseController
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::PatientVisibility

      def new
        difficulty = accesses_patient.needling_assessments.new
        authorize difficulty
        render locals: { difficulty: difficulty }
      end

      def create
        difficulty = accesses_patient.needling_assessments.new(needling_assessment_params)
        authorize difficulty
        if difficulty.save_by(current_user)
          redirect_to patient_accesses_dashboard_path(accesses_patient)
        else
          render :new, locals: { difficulty: difficulty }
        end
      end

      def destroy
        assessment = accesses_patient.needling_assessments.find(params[:id])
        authorize assessment
        assessment.destroy!
        redirect_back(
          fallback_location: patient_accesses_dashboard_path(accesses_patient),
          notice: success_msg_for("needling assessment")
        )
      end

      private

      def needling_assessment_params
        params
          .require(:needling_assessment)
          .permit(:difficulty)
      end
    end
  end
end
