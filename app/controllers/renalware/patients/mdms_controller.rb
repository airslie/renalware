# frozen_string_literal: true

module Renalware
  module Patients
    class MDMsController < BaseController
      include Renalware::Concerns::Pageable
      include Pagy::Backend

      class MDMListOptions
        attr_reader_initialize [
          :search!,
          :rows!,
          :current_view!,
          :view_proc!,
          :pagination!
        ]
      end

      def show
        authorize Patient, :index?
        sql_view_klass = Reporting::SqlView.new(view_name).klass
        sql_view_klass.reset_column_information
        search = sql_view_klass.ransack(params[:q])
        view_proc = lambda { |patient|
          send(:"patient_#{scope_name}_mdm_path", patient_id: patient.secure_id)
        }
        pagy, patients = pagy(search.result)
        options = MDMListOptions.new(
          search: search,
          rows: patients.load,
          current_view: current_view,
          view_proc: view_proc,
          pagination: pagy
        )
        render locals: { options: options, turbo_frame_request: turbo_frame_request? }
      end

      private

      # Some 'mdm' entries in system.view_metadata have a #scope that does not yet have its own
      # MDM patient view so we use a default scope for when building the route to the mdm view.
      def scope_name
        default_scope = "low_clearance"
        case current_view.scope
        when "akcc", "supportive_care" then default_scope
        else current_view.scope
        end
      end

      def view_name
        "#{current_view.schema_name}.#{current_view.view_name}"
      end

      def current_view
        @current_view ||=
          views.detect { |vw| vw.slug == params.fetch(:filter, "all") } || views.first
      end

      def views
        @views ||= begin
          scope = params[:scope]
          System::ViewMetadata.where(
            category: "mdm",
            scope: scope
          ).tap do |relation|
            if relation.empty?
              raise "No SQL views for found for category 'mdm' scope: '#{scope}'"
            end
          end
        end
      end
    end
  end
end
