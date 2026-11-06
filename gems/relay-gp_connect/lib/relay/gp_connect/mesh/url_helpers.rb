module Relay
  module GPConnect
    module Mesh
      # Paths for the MESH API. The including class must provide `config` (a Mesh::Config).
      module UrlHelpers
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

        # E.g. messageexchange/endpointlookup/A81013/GPCONNECT_SEND_DOCUMENT
        def endpointlookup_path(ods_code)
          File.join(config.api_base_url, "endpointlookup", ods_code, config.workflow_id)
        end
      end
    end
  end
end
