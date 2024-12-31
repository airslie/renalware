module Renalware
  module Accesses
    class ProceduresController < BaseController
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::PatientVisibility

      def show
        procedure = find_procedure
        presenter = ProcedurePresenter.new(procedure)
        render locals: { patient: accesses_patient, procedure: presenter }
      end

      def new
        procedure = accesses_patient.procedures.new(by: current_user)
        authorize procedure
        render locals: { patient: accesses_patient, procedure: procedure }
      end

      def edit
        procedure = find_procedure
        render locals: { patient: accesses_patient, procedure: procedure }
      end

      def create
        procedure = accesses_patient.procedures.new(procedure_params)
        authorize procedure

        if procedure.save
          redirect_to patient_accesses_dashboard_path(accesses_patient),
                      notice: success_msg_for("Access procedure")
        else
          flash.now[:error] = failed_msg_for("Access procedure")
          render :new, locals: { patient: accesses_patient, procedure: procedure }
        end
      end

      def update
        procedure = find_procedure

        if procedure.update(procedure_params)
          redirect_to patient_accesses_dashboard_path(accesses_patient),
                      notice: success_msg_for("access procedure")
        else
          flash.now[:error] = failed_msg_for("access procedure")
          render :edit, locals: { patient: accesses_patient, procedure: procedure }
        end
      end

      protected

      def find_procedure
        accesses_patient.procedures.find(params[:id]).tap { |pro| authorize pro }
      end

      def procedure_params
        params
          .require(:accesses_procedure)
          .permit(attributes)
          .merge(by: current_user)
      end

      def attributes
        %i(
          performed_on first_used_on failed_on
          side type_id
          catheter_make catheter_lot_no
          performed_by notes outcome
          pd_catheter_insertion_technique_id
        )
      end
    end
  end
end
