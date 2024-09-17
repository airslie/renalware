# frozen_string_literal: true

module Renalware
  module Clinics
    class AppointmentsController < BaseController
      include Pagy::Backend
      use_layout :simple

      def index
        query = search_form.query
        pagy, appointments = pagy(query.call)
        authorize appointments

        render :index, locals: {
          appointments: appointments,
          form: search_form,
          search: query.search,
          clinics: Clinic.ordered,
          users: User.ordered,
          request_html_form_params: build_params_for_html_form(appointments),
          pagy: pagy
        }
      end

      def new
        render_new(Appointment.new)
      end

      def create
        appointment = Appointment.new(appointment_params)
        authorize appointment
        if appointment.save_by(current_user)
          redirect_to appointments_path, notice: success_msg_for("Appointment")
        else
          render_new(appointment)
        end
      end

      private

      def search_form
        @search_form ||= begin
          options = params.key?(:q) ? search_params : {}
          AppointmentSearchForm.new(options)
        end
      end

      def render_new(appointment)
        authorize appointment
        render :new, locals: { appointment: appointment }
      end

      def build_params_for_html_form(appointments)
        OpenStruct.new(
          patient_ids: appointments.map(&:patient_id).uniq
        )
      end

      def query_params
        params.fetch(:q, {})
      end

      def search_params
        params
          .require(:q)
          .permit(
            :from_date, :from_date_only, :clinic_id, :consultant_id,
            :s, # handles a ransack sort_link having a single sort arg
            s: [] # handles a ransack sort_link where 3rd is array of sorts
          )
      end

      def appointment_params
        params
          .require(:clinics_appointment)
          .permit(
            :patient_id, :clinic_id,
            :outcome_notes, :starts_at,
            :dna_notes, :consultant_id
          )
      end
    end
  end
end
