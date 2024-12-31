module Renalware
  module Letters::Transports::Mesh
    class InboxMessagesController < BaseController
      include Pagy::Backend
      layout -> { turbo_frame_request? ? "turbo_rails/frame" : "renalware/layouts/admin" }

      def index
        authorize Transmission, :index?
        response = fetch_ids_of_inbox_messages_to_download
        render locals: { message_ids: response.body["messages"] }
      end

      def show
        authorize Transmission, :show?
        response = fetch_message(params[:id])
        render locals: { response: response }
      end

      # Process
      def update
        authorize Transmission, :show?
        message_id = params[:id]
        DownloadMessageJob.perform_now(message_id)
        redirect_to letters_transports_mesh_inbox_messages_path
      end

      private

      def fetch_ids_of_inbox_messages_to_download
        API::LogOperation.new(:check_inbox).call { API::Client.check_inbox }
      end

      def fetch_message(id)
        API::LogOperation.new(:download_message).call { API::Client.download_message(id) }
      end
    end
  end
end
