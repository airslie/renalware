# frozen_string_literal: true

require_dependency "renalware/hd"

module Renalware
  module HD
    class MDMPatientsController < Renalware::MDMPatientsController
      def index
        render_index(
          filter_form: filter_form,
          query: query,
          page_title: t(".page_title"),
          view_proc: ->(patient) { patient_hd_mdm_path(patient) },
          patient_presenter_class: HD::PatientPresenter
        )
      end

      private

      def query
        @query ||= begin
          MDMPatientsQuery.new(
            params: filter_form.ransacked_parameters.merge(query_params).with_indifferent_access,
            named_filter: named_filter
          )
        end
      end

      # Pass in the current path to the filter form so it can render the correct URI in form and
      # reset links.
      def filter_form
        @filter_form ||= form_object_class.new(filter_form_params.merge(url: request.path))
      end

      # Permit all attributes on the filter form object. Slightly messy
      def filter_form_params
        params.fetch(:filter, {}).permit(form_object_class.permittable_attributes)
      end

      def form_object_class
        Renalware::HD::MDMPatientsForm
      end

      # Ransack params use for column sorting
      def query_params
        params.fetch(:q, {}).permit(:s)
      end

      def named_filter
        params[:named_filter]
      end

      def batch_print_form
        patient_ids = query.call.pluck("patients.id").join(",")
        SessionForms::Form.new(patient_ids: patient_ids)
      end

      def render_index(filter_form:, **args)
        presenter = build_presenter(params: params, **args)
        authorize presenter.patients
        render(
          :index,
          locals: {
            presenter: presenter,
            filter_form: filter_form,
            batch_print_form: batch_print_form
          }
        )
      end
    end
  end
end
