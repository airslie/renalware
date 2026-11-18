module Renalware
  module Letters::Transports::Mesh
    module API
      # Records a MESH API call as an Operation: creates the row, yields it to the block that
      # makes the call, then stores what the response says (see OperationAttributes) on it.
      # This is the Renalware-specific persistence; parsing the response is shared.
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

        def yield_block_to_api_call_and_store_response_in_operation(operation, &block)
          response = yield(operation) if block
          return unless response

          store_response(operation, response)
          response
        rescue StandardError => e
          operation.update(unhandled_error: [e.message, e.backtrace].join)
          raise e
        end

        def store_response(operation, response)
          attributes = OperationAttributes.new(response)
          operation.assign_attributes(attributes.to_h)
          operation.mesh_message_id = attributes.message_id if operation.mesh_message_id.blank?
          operation.save!
        end

        def initial_attributes
          {
            uuid: local_id,
            action: action
          }
        end
      end
    end
  end
end
