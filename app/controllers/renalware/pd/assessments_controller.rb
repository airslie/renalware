module Renalware
  module PD
    class AssessmentsController < BaseController
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::PatientVisibility

      def show
        assessment = find_assessment
        authorize assessment
        render locals: { patient: pd_patient, assessment: assessment }
      end

      def new
        assessment = PD::Assessment.for_patient(pd_patient).new
        authorize assessment
        render locals: { patient: pd_patient, assessment: assessment }
      end

      def edit
        assessment = find_assessment
        authorize assessment
        render locals: { patient: pd_patient, assessment: assessment }
      end

      def create
        assessment = PD::Assessment.for_patient(pd_patient).new(assessment_params)
        authorize assessment
        if assessment.save_by(current_user)
          redirect_to patient_pd_dashboard_path(pd_patient),
                      notice: success_msg_for("assessment")
        else
          render :new, locals: { patient: pd_patient, assessment: assessment }
        end
      end

      def update
        assessment = find_assessment
        authorize assessment
        if assessment.update_by(current_user, assessment_params)
          redirect_to patient_pd_dashboard_path(pd_patient),
                      notice: success_msg_for("assessment")
        else
          render :edit, locals: { patient: pd_patient, assessment: assessment }
        end
      end

      private

      def find_assessment
        PD::Assessment.for_patient(pd_patient).find(params[:id])
      end

      def assessment_params
        params.require(:assessment).permit(document: {})
      end
    end
  end
end
