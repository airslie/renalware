module Renalware
  module Accesses
    class AssessmentsController < BaseController
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::PatientVisibility

      def show
        render locals: {
          patient: accesses_patient,
          assessment: AssessmentPresenter.new(find_and_authorize_assessment)
        }
      end

      def new
        assessment = AssessmentFactory.new(patient: accesses_patient).build
        authorize assessment
        render_new(assessment)
      end

      def edit
        render_edit(find_and_authorize_assessment)
      end

      def create
        assessment = accesses_patient.assessments.new(assessment_params)
        authorize assessment

        if assessment.save_by(current_user)
          redirect_to patient_accesses_dashboard_path(accesses_patient),
                      notice: success_msg_for("Access assessment")
        else
          flash.now[:error] = failed_msg_for("Access assessment")
          render_new(assessment)
        end
      end

      def update
        assessment = find_and_authorize_assessment

        if assessment.update_by(current_user, assessment_params)
          redirect_to patient_accesses_dashboard_path(accesses_patient),
                      notice: success_msg_for("Access assessment")
        else
          flash.now[:error] = failed_msg_for("Access assessment")
          render_edit(assessment)
        end
      end

      protected

      def find_and_authorize_assessment
        accesses_patient.assessments.find(params[:id]).tap { |ass| authorize ass }
      end

      def render_new(assessment)
        render :new, locals: { patient: accesses_patient, assessment: assessment }
      end

      def render_edit(assessment)
        render :edit, locals: { patient: accesses_patient, assessment: assessment }
      end

      def assessment_params
        params.require(:accesses_assessment).permit(attributes)
      end

      def attributes
        [
          :performed_on, :first_used_on, :failed_on,
          :side, :type_id,
          :catheter_make, :catheter_lot_no,
          :performed_by, :notes, :outcome, :comments,
          document: {}
        ]
      end
    end
  end
end
