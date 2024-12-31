module Renalware
  module Reporting
    # Asynchronously refresh the materialized view associated with the ViewMetadata
    class ViewMetadataRefreshmentsController < BaseController
      def create
        authorize view_metadata

        System::RefreshMaterializedViewWithMetadataJob.perform_later(view_metadata)

        redirect_back fallback_location: reporting.reports_path,
                      notice: "Materialized View will be refreshed in the " \
                              "background, please check back later"
      end

      private

      def view_metadata
        @view_metadata ||= System::ViewMetadata.find(secure_params[:view_metadata_id])
      end

      def secure_params
        params.permit(:view_metadata_id)
      end
    end
  end
end
