class CreateLetterDeliveryMeshOperations < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      enable_extension "pgcrypto" unless extension_enabled?("pgcrypto")

      create_enum :enum_mesh_itk3_response_type, %w(
        inf
        bus
        unknown
      )

      create_enum :enum_mesh_message_direction, %w(
        outbound
        inbound
      )

      create_enum :enum_mesh_api_action, %w(
        endpointlookup
        handshake
        check_inbox
        download_message
        acknowledge_message
        send_message
      )

      table_comment = <<-COMMENT.squish
        Each row represents a MESH API message.
        There are two types of message
        - outbound XML FHIR messages containing the letter content and supporting metadata
        - inbound XML FHIR messages containing a business or infrastructure response.
        The direction column specifies the direction.
      COMMENT

      create_table :letter_mesh_operations, comment: table_comment do |t|
        t.uuid(
          :uuid,
          default: "uuid_generate_v4()",
          null: false
        )
        t.enum(
          :direction,
          enum_type: :enum_mesh_message_direction,
          null: false,
          default: :outbound,
          index: true,
          comment: "See enum for options"
        )
        t.enum(
          :action,
          enum_type: :enum_mesh_api_action,
          null: false
        )
        t.references(
          :transmission,
          foreign_key: { to_table: :letter_mesh_transmissions },
          index: true,
          comment: "A reference to the transmission 'transaction'"
        )

        t.references(
          :parent,
          foreign_key: { to_table: :letter_mesh_operations },
          index: true,
          null: true,
          comment: "Parent operation - if if we are a download_message operation which needs to " \
                   "be associated with the earlier, parent send_message operation"
        )
        t.text(
          :mesh_message_id,
          comment: "The MESH message id for this message"
        )
        t.jsonb(
          :request_headers,
          comment: "Optional, useful for testing"
        )
        t.jsonb(
          :response_headers,
          comment: "Optional, useful for testing"
        )
        t.text(
          :payload,
          comment: "The XML message body"
        )
        t.text(
          :response_body,
          comment: "The response body (eg JSON) if the message is outbound"
        )
        t.text(
          :unhandled_error,
          comment: "Stores an unexpected exception"
        )
        # Store HTTP response if this is an outgoing message.
        t.integer(
          :http_response_code,
          comment: "eg 200, 401"
        )
        t.text(
          :http_response_description,
          comment: "e.g. OK, Unauthorised"
        )
        t.boolean(
          :http_error,
          comment: "true is eg response status > 299",
          default: false,
          null: false
        )

        # Store MESH API response if this is an outgoing message and a JSON response was returned
        # from MESH API end point.
        t.text(
          :mesh_response_error_code,
          comment: "MESH EPL mailbox/NHS number error code eg EPL-153"
        )
        t.text(
          :mesh_response_error_description,
          comment: "e.g. for EPL-153, 'NHS Number not found'"
        )
        t.text(
          :mesh_response_error_event,
          comment: "eg SEND"
        )
        t.boolean(
          :mesh_error,
          comment: "true if a MESH error was returned from a API call",
          default: false,
          null: false
        )

        # If this is an incoming infrastructure or business response, store the response details
        t.enum(
          :itk3_response_type,
          enum_type: :enum_mesh_itk3_response_type,
          index: true,
          comment: "Incoming messages, where they are an async response to a previously sent " \
                   "message will be of type 'infrastructure' or 'business'"
        )
        t.text(
          :itk3_response_code,
          comment: "from MessageHeader/response/code, e.g. fatal-error"
        )
        t.text(
          :itk3_operation_outcome_type,
          comment: "from OperationOutcome/issue/code, eg processing, security etc"
        )
        t.text(
          :itk3_operation_outcome_severity,
          comment: "from MessageHeader/response/severity, e.g. fatal, success"
        )
        t.text(
          :itk3_operation_outcome_code,
          comment: "from OperationOutcome/issues/details/coding/code - a numeric code e.g. 20001"
        )
        t.text(
          :itk3_operation_outcome_description,
          comment: "from OperationOutcome/issues/details/coding/display - code description eg " \
                   "'Handling Specification Error'"
        )
        t.boolean(
          :itk3_error,
          comment: "true if an ITK3 error was returned in a business or infrastructure reply",
          default: false,
          null: false
        )

        t.timestamps null: false, index: true
      end
    end
  end
end
