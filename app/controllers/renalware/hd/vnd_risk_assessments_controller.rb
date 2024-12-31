module Renalware
  module HD
    class VNDRiskAssessmentsController < BaseController
      include Renalware::Concerns::PatientVisibility
      include Renalware::Concerns::PatientCasting

      def new
        assessment = hd_patient.vnd_risk_assessments.build
        authorize assessment
        save_path_to_return_to
        presenter = VNDRiskAssessmentPresenter.new(assessment)
        render locals: { assessment: presenter }
      end

      def edit
        assessment = hd_patient.vnd_risk_assessments.find(params[:id])
        authorize assessment
        save_path_to_return_to
        presenter = VNDRiskAssessmentPresenter.new(assessment)
        render locals: { assessment: presenter }
      end

      def create
        assessment = hd_patient.vnd_risk_assessments.build(assessment_params)
        authorize assessment
        if assessment.save_by(current_user)
          redirect_to return_url, notice: success_msg_for("VND risk assessment")
          session.delete(:return_to)
        else
          render_new(assessment)
        end
      end

      def update
        assessment = hd_patient.vnd_risk_assessments.find(params[:id])
        authorize assessment
        if assessment.update_by(current_user, assessment_params)
          redirect_to return_url, notice: success_msg_for("VND risk assessment")
          session.delete(:return_to)
        else
          render_edit(assessment)
        end
      end

      def destroy
        assessment = hd_patient.vnd_risk_assessments.find(params[:id])
        authorize assessment
        assessment.destroy
        redirect_back(
          fallback_location: fallback_url,
          notice: success_msg_for("VND risk assessment")
        )
      end

      private

      def render_new(assessment)
        render :new, locals: { assessment: VNDRiskAssessmentPresenter.new(assessment) }
      end

      def render_edit(assessment)
        render :edit, locals: { assessment: VNDRiskAssessmentPresenter.new(assessment) }
      end

      def assessment_params
        params
          .require(:assessment_params)
          .permit(:risk1, :risk2, :risk3, :risk4)
      end

      def save_path_to_return_to
        return unless request.format == :html

        session[:return_to] ||= request.referer
      end

      def fallback_url = patient_hd_dashboard_path(hd_patient)

      def return_url
        @return_url ||= begin
          path = session[:return_to]
          path = nil if path == new_patient_hd_vnd_risk_assessment_path(hd_patient)
          path || fallback_url
        end
      end
      helper_method :return_url
    end
  end
end
