module Renalware
  module Patients
    class DeathsController < BaseController
      include PresenterHelper
      include Pagy::Backend

      def index
        query = Patients::DeceasedPatientsQuery.new(params[:q], scope: patient_scope)
        pagy, patients = pagy(query.call.includes(previous_modality: :description))
        authorize patients
        render locals: {
          patients: present(patients, PatientPresenter),
          q: query.search,
          pagy: pagy
        }
      end

      def edit
        authorize patient
        render_edit
      end

      def update
        authorize patient
        patient.do_death_validations = true
        if patient.update(death_params)
          redirect_to patient_clinical_profile_path(patient),
                      notice: success_msg_for("patient")
        else
          flash.now[:error] = failed_msg_for("patient")
          render_edit
        end
      end

      private

      def render_edit
        render :edit, locals: { patient: patient }
      end

      def death_params
        params
          .require(:patient)
          .permit(
            :died_on, :first_cause_id, :second_cause_id,
            :death_notes, :actual_death_location_id
          ).merge(by: current_user)
      end
    end
  end
end
