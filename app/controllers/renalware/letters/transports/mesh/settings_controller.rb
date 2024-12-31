module Renalware
  module Letters::Transports::Mesh
    class SettingsController < BaseController
      layout -> { turbo_frame_request? ? "turbo_rails/frame" : "renalware/layouts/admin" }

      def show
        authorize Transmission, :index?
        render locals: { settings: settings }
      end

      private

      def settings
        {
          mesh_mailbox_id: Renalware.config.mesh_mailbox_id,
          mesh_api_base_url: Renalware.config.mesh_api_base_url,
          mesh_recipient_mailbox_id: Renalware.config.mesh_recipient_mailbox_id,
          mesh_workflow_id: Renalware.config.mesh_workflow_id,
          mesh_path_to_nhs_ca_file: Renalware.config.mesh_path_to_nhs_ca_file,
          mesh_path_to_client_cert: Renalware.config.mesh_path_to_client_cert,
          mesh_path_to_client_key: Renalware.config.mesh_path_to_client_key,
          mesh_mailbox_password: "***", # Renalware.config.mesh_mailbox_password
          mesh_api_secret: "***" # Renalware.config.mesh_api_secret
        }
      end
    end
  end
end
