module Renalware
  module HD
    class AcuityAssessmentsController < BaseController
      include Renalware::Concerns::PatientCasting

      def index
        pagy, assessments = pagy(AcuityAssessment.for_patient(hd_patient).ordered)
        authorize assessments
        render Views::HD::AcuityAssessments::Index.new(
          assessments:,
          patient:,
          current_user:,
          pagy:
        )
      end

      def new
        assessment = hd_patient.acuity_assessments.new
        authorize assessment
        render_new(assessment)
      end

      def create
        assessment = hd_patient.acuity_assessments.new(assessment_params)
        authorize assessment
        if assessment.save_by(current_user)
          redirect_to(
            return_to || patient_hd_dashboard_path(hd_patient),
            notice: success_msg_for("Acuity assessment")
          )
        else
          render_new(assessment, return_to:)
        end
      end

      def destroy
        assessment = find_assessment
        authorize assessment
        assessment.destroy!
        redirect_back(
          fallback_location: patient_hd_dashboard_path(hd_patient),
          notice: success_msg_for("HD Acuity Assessment")
        )
      end

      private

      def find_assessment
        AcuityAssessment.for_patient(hd_patient).find(params[:id])
      end

      def render_new(assessment, return_to: request.referer)
        render Views::HD::AcuityAssessments::New.new(
          assessment:,
          return_to:
        )
      end

      def assessment_params
        params
          .require(:hd_acuity_assessment)
          .permit(:ratio)
          .merge(by: current_user)
      end

      def return_to = params[:return_to]
    end
  end
end
