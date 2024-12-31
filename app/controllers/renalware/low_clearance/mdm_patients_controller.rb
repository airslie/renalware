module Renalware
  module LowClearance
    class MDMPatientsController < Renalware::MDMPatientsController
      include Concerns::PatientVisibility

      def index
        render_index(
          filter_form: filter_form,
          query: query,
          page_title: t(".page_title"),
          view_proc: ->(patient) { patient_low_clearance_mdm_path(patient) }
        )
      end

      private

      def query
        @query ||= LowClearance::MDMPatientsQuery.new(
          relation: policy_scope(LowClearance::Patient),
          params: filter_form.ransacked_parameters.merge(query_params).with_indifferent_access,
          named_filter: named_filter
        )
      end

      def named_filter
        params[:named_filter]
      end

      # Permit all attributes on the filter form object. Slightly messy
      def filter_form_params
        params.fetch(:filter, {}).permit(form_object_class.permittable_attributes)
      end

      def form_object_class
        LowClearance::MDMPatientsForm
      end

      # Ransack params use for column sorting
      def query_params
        params.fetch(:q, {}).permit(:s)
      end

      # Pass in the current path to the filter form so it can render the correct URI in form and
      # reset links.
      def filter_form
        @filter_form ||= form_object_class.new(filter_form_params.merge(url: request.path))
      end

      def render_index(filter_form:, **)
        presenter = build_presenter(params: params, **)
        authorize presenter.patients
        render(
          :index,
          locals: {
            presenter: presenter,
            filter_form: filter_form
          }
        )
      end
    end
  end
end
