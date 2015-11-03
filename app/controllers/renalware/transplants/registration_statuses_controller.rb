module Renalware
  module Transplants
    class RegistrationStatusesController < BaseController
      before_filter :load_patient
      before_filter :load_registration

      def create
        authorize @registration

        if @status = @registration.add_status!(status_params)
          redirect_to patient_transplants_dashboard_path(@patient)
        else
          render :edit
        end
      end


      def edit
        authorize @registration

        @status = @registration.statuses.find(params[:id])
      end

      def update
        authorize @registration

        status = @registration.statuses.find(params[:id])
        @status = @registration.update_status!(status, status_params)

        if @status.valid?
          redirect_to patient_transplants_dashboard_path(@patient)
        else
          render :edit
        end
      end

      def destroy
        authorize @registration

        status = @registration.statuses.find(params[:id])
        @registration.delete_status!(status)

        redirect_to patient_transplants_dashboard_path(@patient)
      end

      protected

      def load_registration
        @registration = Registration.for_patient(@patient).first_or_initialize
      end

      def status_params
        statuses_attributes = [:started_on, :description_id]
        params.require(:transplants_registration_status).permit(statuses_attributes)
      end
    end
  end
end
