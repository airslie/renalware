module Renalware
  module Pathology
    class RequiredObservationsController < BaseController
      include Renalware::Concerns::PatientVisibility
      include Renalware::Concerns::PatientCasting

      def index
        authorize pathology_patient
        request_params = Requests::RequestParamsFactory.new(raw_request_params).build
        request = Requests::RequestFactory.new(pathology_patient, request_params).build

        render :index, locals: {
          request_html_form_params: build_params_for_html_form,
          request: request,
          all_clinics: all_clinics
        }
      end

      private

      def build_params_for_html_form
        OpenStruct.new(
          patient_ids: [pathology_patient.id],
          clinic_id: raw_request_params[:clinic_id]
        )
      end

      def raw_request_params
        params
          .fetch(:request, {})
          .permit(:clinic_id)
      end

      def all_clinics
        Renalware::Pathology::Clinic.for_algorithm
      end
    end
  end
end
