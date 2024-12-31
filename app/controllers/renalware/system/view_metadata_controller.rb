module Renalware
  module System
    class ViewMetadataController < BaseController
      def edit
        klass = klass_for_view(view_name)
        render locals: { view: view, klass: klass }, layout: false
      end

      def update
        view = find_and_authorize_view
        authorize view
        if view.update(view_metadata_params)
          redirect_back fallback_location: dashboard_path
        end
      end

      # Restore the view to previous version at a specific datetime
      def restore
        view = find_and_authorize_view
        datetime_version_to_restore = params[:version_at]
        view.paper_trail.version_at(datetime_version_to_restore).save!
        redirect_back(fallback_location: root_url)
      end

      private

      def view
        @view ||= find_and_authorize_view
      end

      def view_name
        "#{view.schema_name}.#{view.view_name}"
      end

      # Dynamically create an anonymous AR class to wrap the view so we can get
      # pagination etc without having to work with PG::Result.
      def klass_for_view(view_name)
        Class.new(ApplicationRecord) do
          extend RansackAll
          self.table_name = view_name
          define_method(:to_s, ->(_x) { patient_name })
          define_method(:to_param, -> { secure_id })
        end.tap do |klass|
          Object.const_set(:AnonymousView, klass) # required for ransack search_form_for
          klass.connection
        end
      end

      def find_and_authorize_view
        ViewMetadata.find(params[:id]).tap { |view| authorize view }
      end

      def view_metadata_params
        params
          .require(:view_metadata)
          .permit(filters: {}, columns: [%i(code name width truncate hidden)])
      end
    end
  end
end
