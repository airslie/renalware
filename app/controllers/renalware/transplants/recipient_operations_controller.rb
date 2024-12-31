module Renalware
  module Transplants
    class RecipientOperationsController < BaseController
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::PatientVisibility

      def show
        render locals: {
          patient: transplants_patient,
          recipient_operation: find_and_authorize_operation
        }
      end

      def new
        operation = RecipientOperation.new
        authorize operation
        render locals: {
          patient: transplants_patient,
          recipient_operation: operation
        }
      end

      def edit
        render locals: {
          patient: transplants_patient,
          recipient_operation: find_and_authorize_operation
        }
      end

      def create
        recipient_operation = RecipientOperation.new(patient: transplants_patient)
        recipient_operation.attributes = operation_params
        authorize recipient_operation

        if recipient_operation.save
          redirect_to patient_transplants_recipient_dashboard_path(transplants_patient),
                      notice: success_msg_for("recipient operation")
        else
          flash.now[:error] = failed_msg_for("recipient operation")
          render :new,
                 locals: {
                   patient: transplants_patient,
                   recipient_operation: recipient_operation
                 }
        end
      end

      def update
        operation = find_and_authorize_operation
        operation.attributes = operation_params

        if operation.save
          redirect_to patient_transplants_recipient_dashboard_path(transplants_patient),
                      notice: success_msg_for("recipient operation")
        else
          flash.now[:error] = failed_msg_for("recipient operation")
          render :edit, locals: { patient: transplants_patient, recipient_operation: operation }
        end
      end

      protected

      def find_and_authorize_operation
        RecipientOperation
          .for_patient(transplants_patient)
          .find(params[:id])
          .tap { |op| authorize op }
      end

      def operation_params
        params
          .require(:transplants_recipient_operation)
          .permit(attributes)
          .merge(document: document_attributes)
      end

      def attributes
        [
          :performed_on, :theatre_case_start_time,
          :donor_kidney_removed_from_ice_at, :kidney_perfused_with_blood_at,
          :operation_type, :hospital_centre_id, :immunological_risk,
          :cold_ischaemic_time_formatted, :warm_ischaemic_time_formatted, :notes,
          :transplant_failed, :failed_on, :failure_cause, :failure_description, :stent_removed_on,
          :induction_agent_id, document: []
        ]
      end

      def document_attributes
        params
          .require(:transplants_recipient_operation)
          .fetch(:document, nil)
          .try(:permit!)
      end
    end
  end
end
