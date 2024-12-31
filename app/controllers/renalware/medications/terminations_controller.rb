module Renalware
  module Medications
    class TerminationsController < BaseController
      include PresenterHelper
      include Concerns::ReturnTo

      before_action :load_patient

      def new
        termination = prescription.build_termination(terminated_on: Date.current)

        render_form(
          prescription, termination,
          url: patient_medications_prescription_termination_path(patient, prescription)
        )
      end

      def create
        termination = prescription.build_termination(termination_params)

        if termination.save(validate: false)
          redirect_to return_to_param || patient_prescriptions_path(patient)
        else
          render_form(
            prescription, termination,
            url: patient_medications_prescription_termination_path(patient,
                                                                   prescription)
          )
        end
      end

      private

      def prescription
        @prescription ||= patient.prescriptions.find(params[:prescription_id])
      end

      def termination_params
        params
          .require(:medications_prescription_termination)
          .permit(:terminated_on, :notes)
          .merge(by: current_user)
      end

      def render_form(prescription, termination, url:)
        render :new, locals: {
          patient: patient,
          prescription: present(prescription, PrescriptionPresenter),
          termination: termination,
          url: url
        }
      end
    end
  end
end
