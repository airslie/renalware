# frozen_string_literal: true

module Renalware
  module Letters::Transports::Mesh
    module API
      # See:
      # https://digital.nhs.uk/developer/api-catalogue/message-exchange-for-social-care-and-health-api
      class Client
        include API::UrlHelpers

        # Create convenience class-level methods that delegate to an instance.
        # Could metaprogram but I think its clearer not to here.
        def self.endpointlookup(...)      = new.endpointlookup(...)
        def self.handshake(...)           = new.handshake(...)
        def self.check_inbox(...)         = new.check_inbox(...)
        def self.download_message(...)    = new.download_message(...)
        def self.acknowledge_message(...) = new.acknowledge_message(...)
        def self.send_message(...)        = new.send_message(...)

        # GET /messageexchange/endpointlookup/{ods_code}/{workflow_id}
        # Find the MESH mailbox is for a particular ODS code (practice code).
        # Example response
        # {
        #   "query_id"=>"20230429091521807_c324d39d",
        #   "results"=>[
        #     {
        #       "address"=>"YGM24GPXXX",
        #       "description"=>"Transfer of Care TPP Mailbox One",
        #       "endpoint_type"=>"MESH"
        #     }
        #   ]
        # }
        def endpointlookup(ods_code)
          connection.get(endpointlookup_path(ods_code))
        end

        # GET /messageexchange/{mailbox_id}/
        # From the MESHAPI docs re handshake (which is just an HTTP GET to the mailbox url):
        #   Use this endpoint to check that MESH can be reached and that the authentication you are
        #   using is correct. This endpoint only needs to be called once every 24 hours. This
        #   endpoint updates the details of the connection history held for your mailbox and is
        #   similar to a keep-alive or ping message, in that it allows monitoring on the Spine to be
        #   aware of the active use of a mailbox despite a lack of traffic.
        #
        # Will be called by a scheduled task every 24 hours.
        #
        # On success the response will echo back the mailbox_id e.g.: '{"mailboxId":"RAJ01OT001'"}'
        # Of the mailbox is not found we still get a 200 but an error message in the body eg
        #   {"errorEvent":"SEND", "errorCode":"EPL-151","errorDescription":"No mailbox matched"}
        def handshake
          connection.get(handshake_path)
        end

        # GET /messageexchange/{mailbox_id}/inbox/
        # Query our MESH inbox for 'infrastructure' and 'business' responses
        # returns eg {"messages": []}
        def check_inbox
          connection.get(inbox_path)
        end

        # GET /messageexchange/{mailbox_id}/inbox/{message_id}
        # From the MESHAPI docs:
        #   Use this endpoint to retrieve a message based on the message identifier obtained from
        #   the 'Check Inbox' endpoint.
        def download_message(message_id)
          connection.get(download_message_path(message_id))
        end

        # PUT /messageexchange/{mailbox_id}/inbox/{message_id}/status/acknowledged
        # From the MESHAPI docs:
        #   Use this endpoint to acknowledge the successful download of a message.
        #   This operation:
        #   - closes the message transaction on Spine
        #   - removes the message from your mailbox inbox, which means that the message identifier
        #     does not appear in subsequent calls to the 'Check inbox' endpoint and cannot be
        #     downloaded again
        #   Note: If you fail to acknowledge a message after five days in the inbox this sends a
        #   non-delivery report to the sender's inbox.
        # Example response:
        #  { "messageId" : "20200529155357895317_3573F8" }
        def acknowledge_message(message_id)
          connection.put(msg_acknowledged_path(message_id))
        end

        # POST /messageexchange/{mailbox_id}/outbox/
        # Send an XML message over MESH.
        # Example response:
        #  { "messageID": "20200529155357895317_3573F8" }
        def send_message(payload, **request_header_options)
          raise(ArgumentError, "Missing Mex-To") if request_header_options[:to].blank?
          raise(ArgumentError, "Missing Mex-Subject") if request_header_options[:subject].blank?

          connection(**request_header_options).post(outbox_path, payload)
        end

        private

        # always parse body into json, store raw in response.env[:raw_body]
        def connection(**request_header_options)
          # request_header_options[:to] ||= Renalware.config.mesh_recipient_mailbox_id
          # request_header_options[:subject] ||= ""
          Faraday.new(
            url: base_url,
            headers: API::RequestHeaders.new(**request_header_options).to_h,
            ssl: ssl_options
          ) do |f|
            f.response :json, preserve_raw: true
          end
        end

        def ssl_options
          certificates = Certificates.new
          {
            verify: false,
            ca_file: certificates.ca_file_path,
            client_cert: certificates.client_cert,
            client_key: certificates.client_key
          }
        end
      end
    end
  end
end
