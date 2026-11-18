module Relay
  module GPConnect
    module Mesh
      # Builds a hash of HTTP headers for MESHAPI requests.
      #
      #  config:       a Mesh::Config
      #  auth_header:  a string, usually omitted so it falls back to AuthHeader.call(config:)
      #                but useful in tests.
      #  subject:      text in the following format:
      #                  [payload-title] for [patient-name], NHS Number: [nhs-number], seen at
      #                  [practice-name], ODS code: [ods-code], version [version]
      #  to:           MUST contain the NHS Number, DOB and Surname of the patient delimited by the
      #                underscore character _. This enables automatic routing of the message to the
      #                registered GP MESH mailbox. Or the target mailbox id.
      class RequestHeaders
        def initialize(config:, auth_header: nil, to: nil, operation_uuid: "", subject: "")
          @config = config
          @auth_header = auth_header
          @to = to
          @operation_uuid = operation_uuid # UUID of the operation, used to track the request
          @subject = subject
        end

        # rubocop:disable-next Metrics/MethodLength
        def to_h
          {
            "Authorization" => auth_header || AuthHeader.call(config:),
            "Mex-ClientVersion" => "ApiDocs==0.0.1",
            "Mex-FileName" => "None",
            "Mex-MessageType" => "DATA",
            "Mex-OSArchitecture" => "x86_64",
            "Mex-OSName" => "Linux",
            "Mex-OSVersion" => "",
            "Mex-WorkflowID" => config.workflow_id,
            "X-OperationID" => operation_uuid,
            "Mex-From" => config.mailbox_id,
            "Mex-To" => to,
            "Mex-Subject" => subject.to_s,
            "Content-Type" => "application/xml",
            "Mex-LocalID" => operation_uuid
          }
        end

        private

        attr_reader :config, :auth_header, :to, :operation_uuid, :subject
      end
    end
  end
end
