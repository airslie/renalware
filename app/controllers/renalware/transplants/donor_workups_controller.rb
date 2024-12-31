module Renalware
  module Transplants
    class DonorWorkupsController < BaseController
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::PatientVisibility

      def show
        workup = find_and_authorize_workup
        if workup.new_record?
          redirect_to edit_patient_transplants_donor_workup_path(transplants_patient)
        else
          render locals: { patient: transplants_patient, workup: workup }
        end
      end

      def edit
        render locals: { patient: transplants_patient, workup: find_and_authorize_workup }
      end

      def update
        workup = find_and_authorize_workup
        if workup.update(workup_params)
          redirect_to patient_transplants_donor_workup_path(transplants_patient),
                      notice: success_msg_for("donor work up")
        else
          flash.now[:error] = failed_msg_for("donor work up")
          render :edit, locals: { patient: transplants_patient, workup: workup }
        end
      end

      private

      def find_and_authorize_workup
        DonorWorkup
          .for_patient(transplants_patient)
          .first_or_initialize
          .tap { |workup| authorize workup }
      end

      def workup_params
        params.require(:transplants_donor_workup).permit(document: {})
      end
    end
  end
end
