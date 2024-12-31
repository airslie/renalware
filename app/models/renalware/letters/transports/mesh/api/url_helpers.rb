module Renalware
  module Letters::Transports::Mesh
    module API::UrlHelpers
      extend ActiveSupport::Concern

      # E.g. messageexchange/X26HC005
      def base_url
        File.join(Renalware.config.mesh_api_base_url, Renalware.config.mesh_mailbox_id)
      end

      def handshake_path = ""
      def inbox_path = "inbox"
      def outbox_path = "outbox"

      # E.g. messageexchange/X26HC005/inbox/20200529155357895317_3573F8
      def download_message_path(msg_id) = File.join(inbox_path, msg_id)

      # E.g. messageexchange/X26HC005/inbox/20200529155357895317_3573F8/status/acknowledged
      def msg_acknowledged_path(msg_id) = File.join(inbox_path, msg_id, "status/acknowledged")

      # E.g. messageexchange/endpointlookup/A81013/TOC_FHIR_OP_ATTEN
      def endpointlookup_path(ods_code)
        workflow_id = Renalware.config.mesh_workflow_id
        File.join(Renalware.config.mesh_api_base_url, "endpointlookup", ods_code, workflow_id)
      end
    end
  end
end
