# frozen_string_literal: true

module Renalware
  module Letters::Formats::FHIR
    # 'Parameter Object' Passed to any class rendering part of a FHIR document message.
    # Provides access to a variety of data but without having any business logic.
    class Arguments
      include Renalware::UniformResourceNaming

      attr_reader :transmission,
                  :transaction_uuid,
                  :organisation_uuid,
                  :itk_organisation_uuid

      delegate :letter, to: :transmission
      delegate :uuid, to: :transmission, prefix: true
      delegate :patient, :event, :archive, to: :letter
      delegate :pdf_content, to: :archive
      delegate :uuid, to: :letter, prefix: true
      alias :clinic_visit :event

      WORKFLOWS = {
        gp_connect: {
          event: {
            code: "ITK007C",
            display: "ITK GP Connect Send Document"
          },
          message_definition: {
            reference: "https://fhir.nhs.uk/STU3/MessageDefinition/ITK-GPConnectSendDocument-MessageDefinition-Instance-1"
          }
        },
        transfer_of_care: {
          event: {
            code: "ITK006D",
            display: "ITK Outpatient Letter"
          },
          message_definition: {
            reference: "https://fhir.nhs.uk/STU3/MessageDefinition/ITK-OPL-MessageDefinition-4"
          }
        }
      }.freeze

      def initialize(
        transmission:,
        transaction_uuid:,
        organisation_uuid: nil,
        itk_organisation_uuid: nil
      )
        @transmission = transmission
        @transaction_uuid = transaction_uuid
        @organisation_uuid = organisation_uuid || config.mesh_organisation_uuid
        @itk_organisation_uuid = itk_organisation_uuid || config.mesh_itk_organisation_uuid
        validate_arguments
      end

      def workflow                = Renalware.config.letters_mesh_workflow
      def gp_connect?             = workflow == :gp_connect
      def transmission_urn        = uuid_urn(transmission_uuid)
      def transaction_urn         = uuid_urn(transaction_uuid)
      def letter_urn              = uuid_urn(letter_uuid)
      def patient_urn             = uuid_urn(patient_uuid)
      def encounter_urn           = uuid_urn(encounter_uuid)
      def author_urn              = uuid_urn(author_uuid)
      def organisation_urn        = uuid_urn(organisation_uuid)
      def organisation_name       = config.mesh_organisation_name
      def organisation_ods_code   = config.mesh_organisation_ods_code
      def itk_organisation_urn    = uuid_urn(itk_organisation_uuid)
      def patient_uuid            = patient.secure_id_dashed
      def author_uuid             = letter.author.uuid
      def binary_uuid             = archive.uuid
      def binary_urn              = uuid_urn(binary_uuid)
      def message_definition_url  = WORKFLOWS[workflow].dig(:message_definition, :reference)
      def event_code              = WORKFLOWS[workflow].dig(:event, :code)
      def event_display           = WORKFLOWS[workflow].dig(:event, :display)
      def document_title          = letter.description
      def document_version        = 1
      def confidentiality         = %w(N R).first

      def encounter_uuid
        @encounter_uuid ||= clinic_visit&.uuid || SecureRandom.uuid
      end

      # There are two modes for the Mex-To HTTP Header:
      # - we can use a known mesh mailbox id and send directly there (eg a mailbox id that was
      #   looked up via the endpointlookup using the practice ODS code as we did for Transfer
      #   Of Care)
      # - send a demographics summary string prefixed with GPPROVIDER (to tell the mesh router
      #   the content is not a mailbox_id), in the format: "NHSNUMBER_DOB(yyyymmdd)_surname"
      #   and this will use MESH auto-routing to deliver the message to the correct mailbox
      #   (or return an EPL-* message if it can't resolve the practice mailbox fot the patient)
      def mex_to
        return config.mesh_recipient_mailbox_id if config.mesh_use_endpoint_lookup

        # Use MESH auto routing
        [
          "GPPROVIDER",
          patient.nhs_number,
          patient.born_on.strftime("%Y%m%d"),
          patient.family_name
        ].join("_")
      end

      def mex_subject
        [
          "#{document_title} for #{patient}",
          "NHS Number: #{patient.nhs_number}",
          "seen at #{organisation_name}",
          organisation_ods_code,
          "Version: #{document_version}"
        ].join(", ")
      end

      private

      def config = Renalware.config

      def validate_arguments
        # The try here is because we have a lot of tests that don't stub letter.archive
        if letter.try(:archive).present? && pdf_content.blank?
          raise Letters::MissingPdfContentError
        end
      end
    end
  end
end
