module Renalware
  module Problems
    class ComorbiditiesController < BaseController
      include Renalware::Concerns::PatientVisibility

      def show
        comorbidities = patient.comorbidities
        authorize comorbidities
        render :show, locals: { patient: patient }
      end

      def edit
        comorbidities = patient.comorbidities
        authorize comorbidities

        render :edit, locals: {
          form: Comorbidities::Form.new(patient: patient)
        }
      end

      def update
        authorize Comorbidity, :update?

        Comorbidities::Form.new(
          patient: patient,
          by: current_user,
          params: comorbidity_params
        ).save

        redirect_to patient_comorbidities_path(patient), notice: "Saved"
      end

      private

      def comorbidity_params
        params
          .require(:comorbidity_form)
          .permit(comorbidities_attributes: {})
      end
    end
  end
end
