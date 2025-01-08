# frozen_string_literal: true

module Renalware
  module Clinics
    # Patient-specific appointments
    class PatientAppointmentsController < BaseController
      include Pagy::Backend
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::PatientVisibility

      def index
        query = search_form.query
        pagy, appointments = pagy(query.call)
        authorize appointments
        render locals: {
          search: query.search,
          form: search_form,
          patient: patient,
          clinics: Clinic.ordered,
          appointments: appointments,
          pagy: pagy
        }
      end

      def search_form
        @search_form ||= begin
          options = params.key?(:q) ? search_params : {}
          PatientAppointmentSearchForm.new(options.merge(patient: clinics_patient))
        end
      end

      def query_params
        params.fetch(:q, {})
      end

      def search_params
        params
          .require(:q)
          .permit(
            :clinic_id,
            :consultant_id,
            :s, # handles a ransack sort_link having a single sort arg
            s: [] # handles a ransack sort_link where 3rd is array of sorts
          )
      end
    end
  end
end
