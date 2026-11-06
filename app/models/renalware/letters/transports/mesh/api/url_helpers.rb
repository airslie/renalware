module Renalware
  module Letters::Transports::Mesh
    module API::UrlHelpers
      extend ActiveSupport::Concern

      # The including class can supply its own `config` (an API::Config); otherwise we use the
      # settings in Renalware.config.
      def config = @config ||= API::Config.from_renalware

      # E.g. messageexchange/X26HC005
      def base_url
        File.join(config.api_base_url, config.mailbox_id)
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
        File.join(config.api_base_url, "endpointlookup", ods_code, config.workflow_id)
      end
    end
  end
end
