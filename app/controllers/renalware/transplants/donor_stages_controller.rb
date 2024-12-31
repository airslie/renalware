module Renalware
  module Transplants
    class DonorStagesController < BaseController
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::PatientVisibility

      def new
        stage = DonorStage.new(patient: transplants_patient)
        authorize stage
        render locals: {
          patient: transplants_patient,
          stage: stage
        }
      end

      def create
        authorize donor_stage
        result = CreateDonorStage.new(
          patient: transplants_patient,
          options: donor_stage_params
        ).call
        if result.success?
          redirect_to patient_transplants_donor_dashboard_path(transplants_patient),
                      notice: success_msg_for("donor stage")
        else
          render :new, locals: {
            patient: transplants_patient,
            stage: result.object
          }
        end
      end

      private

      def donor_stage
        @donor_stage ||= DonorStage.for_patient(transplants_patient).first_or_initialize
      end

      def donor_stage_params
        params
          .require(:donor_stage)
          .permit(:started_on, :stage_position_id, :stage_status_id, :notes)
          .to_h
          .merge(by: current_user)
      end
    end
  end
end
