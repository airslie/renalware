module Renalware
  module System
    class DownloadsController < BaseController
      include Pagy::Backend

      def index
        query = DownloadQuery.new(params[:q])
        pagy, items = pagy(query.call)
        authorize items
        render locals: { items: items, search: query.search, pagy: pagy }
      end

      # Redirects the uploaded file eg PDF etc
      def show
        download = find_and_authorize_download
        if download.file.attached?
          update_view_count_for download
          redirect_to(raw_active_storage_url_for(download.file))
        end
      end

      def new
        download = Download.new
        authorize download
        render_new(download)
      end

      def edit
        render_edit(find_and_authorize_download)
      end

      def create
        download = Download.new(download_params)
        authorize download
        if download.save_by(current_user)
          redirect_to system_downloads_path, notice: notice
        else
          render_new(download)
        end
      end

      def update
        download = find_and_authorize_download
        if download.update_by(current_user, download_params)
          redirect_to system_downloads_path, notice: notice
        else
          render_edit(download)
        end
      end

      # Rather than calling #destroy on the record, we manually update the
      # deleted_at column so the record is hidden (soft deleted). Of course
      # acts_as_paranoid would have done this for us on #destroy, but
      # activestorage would also delete the underlying attachment and blob, which we
      # do not want as it defeats the point of a soft-delete! (At the time of writing activestorage
      # does not have an option to skip purging after a delete).
      # The downside of this approach is that no delete callbacks will be triggered.
      def destroy
        find_and_authorize_download.update_by(current_user, deleted_at: Time.zone.now)
        redirect_to system_downloads_path, notice: notice
      end

      private

      def render_new(download)
        render :new, locals: { download: download }
      end

      def render_edit(download)
        render :edit, locals: { download: download }
      end

      def find_and_authorize_download
        Download.find(params[:id]).tap { |download| authorize download }
      end

      def download_params
        params.require(:download).permit(:name, :description, :file)
      end

      def notice
        success_msg_for("download")
      end

      def update_view_count_for(download)
        download.update_column(:view_count, download.view_count + 1)
      end

      def raw_active_storage_url_for(file)
        Rails.application.routes.url_helpers.rails_blob_url(file.attachment, only_path: true)
      end
    end
  end
end
