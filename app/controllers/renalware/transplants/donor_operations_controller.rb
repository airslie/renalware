module Renalware
  module Transplants
    class DonorOperationsController < BaseController
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::PatientVisibility

      def show
        operation = find_and_authorize_operation
        render locals: { patient: transplants_patient, operation: operation }
      end

      def new
        operation = DonorOperation.new
        authorize operation
        render_new(operation)
      end

      def edit
        render_edit(find_and_authorize_operation)
      end

      def create
        operation = DonorOperation.new(patient: transplants_patient)
        operation.attributes = operation_params
        authorize operation

        if operation.save
          redirect_to patient_transplants_donor_dashboard_path(transplants_patient),
                      notice: success_msg_for("donor operation")
        else
          flash.now[:error] = failed_msg_for("donor operation")
          render_new(operation)
        end
      end

      def update
        operation = find_and_authorize_operation
        operation.attributes = operation_params

        if operation.save
          redirect_to patient_transplants_donor_dashboard_path(transplants_patient),
                      notice: success_msg_for("donor operation")
        else
          flash.now[:error] = failed_msg_for("donor operation")
          render_edit(operation)
        end
      end

      protected

      def find_and_authorize_operation
        DonorOperation
          .for_patient(transplants_patient)
          .find(params[:id])
          .tap { |operation| authorize operation }
      end

      def render_edit(operation)
        render :edit, locals: { patient: transplants_patient, operation: operation }
      end

      def render_new(operation)
        render :new, locals: { patient: transplants_patient, operation: operation }
      end

      def operation_params
        params
          .require(:transplants_donor_operation)
          .permit(attributes)
          .merge(document: document_attributes)
      end

      def attributes
        [
          :performed_on, :notes,
          :anaesthetist, :donor_splenectomy_peri_or_post_operatively, :kidney_side,
          :nephrectomy_type, :nephrectomy_type_other, :operating_surgeon,
          document: []
        ]
      end

      def document_attributes
        params
          .require(:transplants_donor_operation)
          .fetch(:document, nil)
          .try(:permit!)
      end
    end
  end
end
