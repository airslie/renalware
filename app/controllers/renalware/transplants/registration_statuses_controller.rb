module Renalware
  module Transplants
    class RegistrationStatusesController < BaseController
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::PatientVisibility

      def new
        status = registration.statuses.build
        authorize status
        render locals: {
          patient: transplants_patient,
          status: status
        }
      end

      def edit
        status = registration.statuses.find(params[:id])
        authorize status
        render locals: {
          patient: transplants_patient,
          status: status
        }
      end

      def create
        status = registration.add_status!(status_params)
        authorize status
        if status.valid?
          redirect_to patient_transplants_recipient_dashboard_path(transplants_patient),
                      notice: success_msg_for("registration status")
        else
          flash.now[:error] = failed_msg_for("registration status")
          render :new, locals: { patient: transplants_patient, status: status }
        end
      end

      def update
        status = update_status
        if status.valid?
          redirect_to patient_transplants_recipient_dashboard_path(transplants_patient),
                      notice: success_msg_for("registration status")
        else
          flash.now[:error] = failed_msg_for("registration status")
          render :edit, locals: { patient: transplants_patient, status: status }
        end
      end

      def destroy
        status = registration.statuses.find(params[:id])
        registration.delete_status!(status)

        redirect_to patient_transplants_recipient_dashboard_path(transplants_patient),
                    notice: success_msg_for("registration status")
      end

      protected

      def update_status
        existing_status = registration.statuses.find(params[:id])
        registration.update_status!(existing_status, status_params)
      end

      def registration
        @registration ||= Registration.for_patient(transplants_patient).first_or_initialize
      end

      def status_params
        params
          .require(:transplants_registration_status)
          .permit(:started_on, :description_id, :notes)
          .merge(by: current_user)
      end
    end
  end
end
