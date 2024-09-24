# frozen_string_literal: true

module Renalware
  module Letters
    module Transports::Mesh
      class SendMessageJob < ApplicationJob
        queue_as :mesh
        queue_with_priority 10 # low

        class PatientHasNoPracticeError < StandardError; end
        class GPNotInRecipientsError < StandardError; end

        retry_on Renalware::Letters::MissingPdfContentError, wait: 30.seconds

        def perform(transmission)
          Perform.new(transmission).call
        end

        class Perform
          pattr_initialize :transmission
          delegate :letter, to: :transmission
          delegate :patient, to: :letter
          delegate :primary_care_physician, :practice, to: :patient, allow_nil: true

          def call
            validate_arguments

            # There are two ways to resolve the recipient mailbox,
            # if Renalware.config.mesh_use_endpoint_lookup then we make a separate call to get the
            # mailbox, otherwise we use mesh routing by including patient demographics in the #
            # Mex-To header and the MESH API routes it appropriately.
            lookup_mesh_mailbox_for_practice_if_missing if Renalware.config.mesh_use_endpoint_lookup

            build_payload_and_send_message
          end

          private

          def validate_arguments
            raise(GPNotInRecipientsError, "letter should not be sent") unless gp_is_a_recipient?
            raise PatientHasNoPracticeError if practice.nil?
          end

          def gp_is_a_recipient?
            letter.recipients.any?(&:primary_care_physician?) # only ever zero or one gp recipient
          end

          # EndpointlookupJob will save the mailbox id to the practice if one found.
          def lookup_mesh_mailbox_for_practice_if_missing
            if practice.mesh_mailbox_id.blank?
              EndpointlookupJob.perform_now(practice, transmission_id: transmission.id)
            end
          end

          # rubocop:disable Metrics/MethodLength
          def build_payload_and_send_message
            API::LogOperation.new(:send_message).call(transmission_id: transmission.id) do |op|
              arguments = Formats::FHIR::Arguments.new(
                transmission: transmission,
                transaction_uuid: op.uuid
              )

              op.payload = Formats::FHIR::BuildPayload.call(arguments)

              API::Client.send_message(
                op.payload,
                operation_uuid: op.uuid,
                to: arguments.mex_to,
                subject: arguments.mex_subject
              )
            end
          end
          # rubocop:enable Metrics/MethodLength
        end
      end
    end
  end
end
