# frozen_string_literal: true

require "httparty"

module Renalware
  module Letters::Transports::Mesh
    # Builds a hash of HTTP headers for MESHAPI requests.
    #
    #  auth_header:  a string, usually omitted so it falls back to AuthHeader.new.call
    #                but useful in tests.
    #  subject:      text in the following format:
    #                  [payload-title] for [patient-name], NHS Number: [nhs-number], seen at
    #                  [practice-name], ODS code: [ods-code], version [version]
    #  to:           MUST contain the NHS Number, DOB and Surname of the patient delimited by the
    #                underscore character _. This enables automatic routing of the message to the
    #                registered GP MESH mailbox
    #
    class API::RequestHeaders
      pattr_initialize [
        :auth_header,
        to: "", # patient details (for auto-routing, see above) or target mailbox?
        subject: "",
        operation_uuid: ""
      ]

      # rubocop:disable Metrics/MethodLength
      def to_h
        {
          "Authorization" => auth_header || API::AuthHeader.new.call,
          "Mex-ClientVersion" => "ApiDocs==0.0.1",
          "Mex-FileName" => "None",
          "Mex-MessageType" => "DATA",
          "Mex-OSArchitecture" => "x86_64",
          "Mex-OSName" => "Linux",
          "Mex-OSVersion" => "",
          "Mex-WorkflowID" => Renalware.config.mesh_workflow_id,
          "X-OperationID" => operation_uuid,
          "Mex-From" => Renalware.config.mesh_mailbox_id,
          "Mex-To" => to,
          "Mex-Subject" => subject.to_s,
          "Content-Type" => "application/xml",
          "Mex-LocalID" => Renalware.config.mesh_organisation_ods_code
        }
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
