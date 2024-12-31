module Renalware
  module Letters::Transports::Mesh
    class EndpointlookupJob < ApplicationJob
      queue_as :mesh
      queue_with_priority 10

      # When a Patients::Practice has an ods_code but no MESH mailboxid (endpoint) to send to,
      # we use this job to lookup and store the MESH mailbox in the practice record.
      # Normally we call this only when the practice.mesh_mailbox_id is missing (so perhaps
      # only ever once, as we store/cache it from then on. However its possible a practice might
      # change IT provider eg from TPP to EMIS in which case the mailbox id would change.
      # In this instance the next send operation would indicate in invalid mailbox id, and prompt
      # us to call this job again to get and cache the new one.

      class HttpError < StandardError; end
      class NoMailboxFoundForODSCodeError < StandardError; end
      class MultipleMailboxesFoundForODSCodeError < StandardError; end

      # Passing transmission_id means it will display with other operations under that transmission
      # in the Admin UI
      # rubocop:disable Metrics/MethodLength
      def perform(practice, transmission_id: nil)
        practice_ods_code = practice.code&.strip

        API::LogOperation.new(:endpointlookup).call(transmission_id: transmission_id) do |_op|
          if practice_ods_code.blank?
            raise(ArgumentError, "Practice has no ODS code - cannot lookup endpoint")
          end

          response = API::Client.endpointlookup(practice_ods_code)
          validate_response(response, practice_ods_code)
          result = response.body["results"].first

          practice.update!(
            mesh_mailbox_id: result["address"],
            mesh_mailbox_description: result["description"]
          )

          response
        end

        practice.mesh_mailbox_id
      end
      # rubocop:enable Metrics/MethodLength

      # rubocop:disable Metrics/MethodLength
      def validate_response(response, practice_ods_code)
        unless response.status.between?(200, 299)
          raise HttpError, "Non-success HTTP response code '#{response.status}' #{response.inspect}"
        end

        results = response.body["results"]

        if results.empty?
          raise(
            NoMailboxFoundForODSCodeError,
            "No MESH mailbox id found for ODS code '#{practice_ods_code}'"
          )
        end

        if results.length > 1
          raise(
            MultipleMailboxesFoundForODSCodeError,
            "More than one result looking up mailbox for '#{practice_ods_code}': #{results}"
          )
        end
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
