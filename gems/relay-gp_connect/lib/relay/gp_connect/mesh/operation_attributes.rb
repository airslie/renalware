require "active_support/core_ext/object/blank"

module Relay
  module GPConnect
    module Mesh
      # Turns the response to a MESH API call into a hash of attributes describing it: the HTTP
      # outcome, any MESH error (from a json body, or from the Mex-* headers of an error report),
      # and the ITK3 infrastructure/business response details if it is an xml response.
      #
      # Pure: no database. The host application stores the result however it likes (Renalware
      # keeps it in an Operation row).
      class OperationAttributes
        def initialize(response)
          @response = response
        end

        def to_h
          http_attributes
            .merge(mesh_attributes)
            .merge(itk3_attributes)
            .merge(
              request_headers: response.env["request_headers"],
              response_headers: response.headers,
              response_body: response.body
            )
        end

        # The MESH id of the message just sent, which MESH returns in the json body of the
        # response to a send. Separate from #to_h as the caller may already know the id.
        def message_id = response.body["messageID"]

        private

        attr_reader :response

        def http_attributes
          {
            http_response_code: response.status,
            http_error: response.status >= 300
          }
        end

        def mesh_attributes
          headers = downcased_response_headers

          if headers["content-type"] == "application/json" && response.body.present?
            mesh_attributes_from_body(response.body)
          else
            # its an error report with no body so pull from response headers
            mesh_attributes_from_headers(headers)
          end
        end

        def downcased_response_headers = response.headers.transform_keys(&:downcase)

        def mesh_attributes_from_body(body)
          {
            mesh_error: body["errorDescription"].present?,
            mesh_response_error_event: body["errorEvent"],
            mesh_response_error_code: body["errorCode"],
            mesh_response_error_description: body["errorDescription"]
          }
        end

        def mesh_attributes_from_headers(headers)
          {
            mesh_error: headers["mex-messagetype"] == "REPORT",
            mesh_response_error_event: nil,
            mesh_response_error_code: headers["mex-statuscode"],
            mesh_response_error_description: headers["mex-statusdescription"]
          }
        end

        def itk3_attributes = ITK3Response.new(response).operation_attributes
      end
    end
  end
end
