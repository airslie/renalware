module Renalware
  module Patients
    class WorriesController < BaseController
      before_action :load_patient, only: :create

      # idempotent
      def create
        worry = Worry.find_or_create_by!(patient: patient) do |wor|
          wor.by = user
        end
        worry.update(worry_params.merge!(by: current_user))
        redirect_back fallback_location: patient_path(patient),
                      notice: success_msg_for("patient")
      end

      # idempotent
      def destroy
        if (worry = patient.worry)
          authorize worry
          worry.destroy!
        else
          skip_authorization
        end
        redirect_back fallback_location: patient_path(patient),
                      notice: success_msg_for("worry")
      end

      def edit
        authorize patient.worry
        render :edit, locals: { patient: patient }
      end

      def update
        authorize patient.worry
        if patient.worry.update_by(current_user, worry_params)
          redirect_to params[:worry_source] || patient_path(patient),
                      notice: success_msg_for("worry")
        else
          render :edit, locals: { patient: patient }
        end
      end

      private

      def user
        @user ||= Renalware::Patients.cast_user(current_user)
      end

      def worry_params
        params.require(:patients_worry).permit(:notes, :worry_category_id)
      end
    end
  end
end
