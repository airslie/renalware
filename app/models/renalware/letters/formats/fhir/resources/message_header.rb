# frozen_string_literal: true

module Renalware
  module Letters
    module Formats::FHIR
      #
      # FHIR MessageHeader resource
      # We need to include this in order to ask the receiver to send us
      # async business and infrastructure replies, via BusAckRequested and InfAckRequested
      #
      class Resources::MessageHeader
        include Support::Construction
        include Support::Helpers

        # rubocop:disable Metrics/MethodLength
        def call
          {
            fullUrl: arguments.transaction_urn, # the send_message operation
            resource: FHIR::STU3::MessageHeader.new(
              id: arguments.transaction_uuid,
              timestamp: Time.zone.now.iso8601,
              meta: {
                profile: "https://fhir.nhs.uk/STU3/StructureDefinition/ITK-MessageHeader-2"
              },
              extension: {
                url: "https://fhir.nhs.uk/STU3/StructureDefinition/Extension-ITK-MessageHandling-2",
                extension: [
                  {
                    url: "BusAckRequested",
                    valueBoolean: "true"
                  },
                  {
                    url: "InfAckRequested",
                    valueBoolean: "true"
                  },
                  {
                    url: "RecipientType",
                    valueCoding: {
                      system: "https://fhir.nhs.uk/STU3/CodeSystem/ITK-RecipientType-1",
                      code: "FA", # Alternative is FI which might be more applicable fo CCs
                      display: "For Action" # Alternative is For Information
                    }
                  },
                  {
                    url: "MessageDefinition",
                    valueReference: {
                      reference: arguments.message_definition_url
                    }
                  },
                  {
                    url: "SenderReference",
                    valueString: arguments.letter_urn # i.e. 'our reference'
                  },
                  {
                    url: "LocalExtension",
                    valueString: "NONE"
                  }
                ]
              },
              sender: {
                reference: arguments.organisation_urn
              },
              event: [
                {
                  system: "https://fhir.nhs.uk/STU3/CodeSystem/ITK-MessageEvent-2",
                  code: arguments.event_code,
                  display: arguments.event_display
                }
              ],
              source: {
                endpoint: Renalware.config.mesh_mailbox_id
              },
              focus: {
                reference: arguments.letter_urn
              }
            )
          }
        end
        # rubocop:enable Metrics/MethodLength
      end
    end
  end
end
