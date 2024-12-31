module Renalware
  module Letters::Transports::Mesh
    module API
      class LogOperation
        attr_reader :action, :local_id

        def self.call(action, **, &) = new(action).call(**, &)

        def initialize(action)
          @action = action
          @local_id = SecureRandom.uuid
        end

        def call(**, &)
          operation = Operation.create!(
            initial_attributes.merge(**)
          )
          yield_block_to_api_call_and_store_response_in_operation(operation, &)
        end

        private

        # rubocop:disable Metrics/MethodLength
        def yield_block_to_api_call_and_store_response_in_operation(operation, &block)
          response = yield(operation) if block
          return unless response

          operation.assign_attributes(http_operation_attributes(response))
          operation.assign_attributes(mesh_operation_attributes(response))
          operation.assign_attributes(itk3_operation_attributes(response))
          if operation.mesh_message_id.blank?
            operation.mesh_message_id = response.body["messageID"]
          end
          operation.assign_attributes(common_operation_attributes(response))
          operation.response_body = response.body
          operation.save!
          response
        rescue StandardError => e
          operation.update(unhandled_error: [e.message, e.backtrace].join)
          raise e
        end
        # rubocop:enable Metrics/MethodLength

        def initial_attributes
          {
            uuid: local_id,
            action: action
          }
        end

        def http_operation_attributes(response)
          {
            http_response_code: response.status,
            http_error: response.status >= 300
          }
        end

        def mesh_operation_attributes(response)
          return {} unless response.headers["Content-Type"] == "application/json"

          body = response.body
          {
            mesh_error: body["errorDescription"].present?,
            mesh_response_error_event: body["errorEvent"],
            mesh_response_error_code: body["errorCode"],
            mesh_response_error_description: body["errorDescription"]
          }
        end

        def common_operation_attributes(response)
          return {} if response.nil?

          {
            response_body: response.env["raw_body"],
            request_headers: response.env["request_headers"],
            response_headers: response.headers
          }
        end

        def itk3_operation_attributes(response)
          ITK3Response.new(response).operation_attributes
        end
      end
    end
  end
end
