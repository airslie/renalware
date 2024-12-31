module Renalware
  module PD
    class TrainingSessionsController < BaseController
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::PatientVisibility

      def show
        training_session = find_training_session
        authorize training_session
        render locals: { patient: pd_patient, training_session: training_session }
      end

      def new
        training_session = TrainingSession.for_patient(pd_patient).new
        authorize training_session
        render locals: { patient: pd_patient, training_session: training_session }
      end

      def edit
        training_session = find_training_session
        authorize training_session
        render locals: { patient: pd_patient, training_session: training_session }
      end

      def create
        training_session = TrainingSession.for_patient(pd_patient).new(training_session_params)
        authorize training_session
        if training_session.save_by(current_user)
          redirect_to patient_pd_dashboard_path(pd_patient),
                      notice: success_msg_for("training_session")
        else
          render :new, locals: { patient: pd_patient, training_session: training_session }
        end
      end

      def update
        training_session = find_training_session
        authorize training_session
        if training_session.update_by(current_user, training_session_params)
          redirect_to patient_pd_dashboard_path(pd_patient),
                      notice: success_msg_for("training_session")
        else
          render :edit, locals: { patient: pd_patient, training_session: training_session }
        end
      end

      private

      def find_training_session
        TrainingSession.for_patient(pd_patient).find(params[:id])
      end

      def training_session_params
        params
          .require(:training_session)
          .permit(:training_site_id, :training_type_id, document: {})
      end
    end
  end
end
