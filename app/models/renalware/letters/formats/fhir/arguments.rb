module Renalware
  module Letters::Formats::FHIR
    # 'Parameter Object' Passed to any class rendering part of a FHIR document message.
    # Provides access to a variety of data but without having any business logic.
    class Arguments
      include Renalware::UniformResourceNaming

      # The DeliveryRequest holds everything the GP Connect message needs as plain values, so a
      # message can be built from a request alone (no transmission or letter).
      attr_reader :transmission,
                  :transaction_uuid,
                  :request

      class MissingSnomedDocumentTypeError < StandardError
        def message
          "No Letters::SnomedDocumentType record found having `default_type: true`"
        end
      end

      # The only workflow supported: ITK GP Connect Send Document.
      # (The Transfer of Care workflow was removed; see git tag transfer-of-care-last-present.)
      EVENT_CODE = "ITK007C".freeze
      EVENT_DISPLAY = "ITK GP Connect Send Document".freeze
      MESSAGE_DEFINITION_URL =
        "https://fhir.nhs.uk/STU3/MessageDefinition/ITK-GPConnectSendDocument-MessageDefinition-1"
          .freeze

      # Either pass a transmission (the request is built from its letter), or pass a ready-made
      # request and the transmission_uuid.
      def initialize( # rubocop:disable Metrics/ParameterLists
        transaction_uuid:,
        transmission: nil,
        request: nil,
        transmission_uuid: nil,
        organisation_uuid: nil,
        itk_organisation_uuid: nil
      )
        @transmission = transmission
        @transaction_uuid = transaction_uuid
        @transmission_uuid = transmission_uuid
        @request = request || Letters::BuildDeliveryRequest.new(
          letter: transmission.letter,
          organisation_uuid:,
          itk_organisation_uuid:
        ).lazy
        validate_arguments
      end

      def letter = transmission&.letter
      def transmission_uuid = @transmission_uuid || transmission.uuid

      def transmission_urn        = uuid_urn(transmission_uuid)
      def transaction_urn         = uuid_urn(transaction_uuid)
      def letter_urn              = uuid_urn(letter_uuid)
      def patient_urn             = uuid_urn(patient_uuid)
      def author_urn              = uuid_urn(author_uuid)
      def organisation_urn        = uuid_urn(organisation_uuid)
      def organisation_uuid       = request.sender.uuid
      def itk_organisation_uuid   = request.sender.itk_uuid
      def organisation_name       = request.sender.name
      def organisation_ods_code   = request.sender.ods_code
      def letter_uuid             = request.document.uuid
      def document_type_snomed_code  = request.document.type_snomed_code
      def document_type_snomed_title = request.document.type_snomed_title
      def pdf_content             = request.document.pdf_content
      def itk_organisation_urn    = uuid_urn(itk_organisation_uuid)
      def patient_uuid            = request.patient.uuid
      def author_uuid             = request.author.uuid
      def binary_uuid             = request.document.binary_uuid
      def binary_urn              = uuid_urn(binary_uuid)
      def message_definition_url  = MESSAGE_DEFINITION_URL
      def event_code              = EVENT_CODE
      def event_display           = EVENT_DISPLAY
      def document_version        = 1
      def confidentiality         = request.patient.restricted ? "R" : "N"
      def letter_datetime         = request.document.approved_at.utc.iso8601
      def composition_title       = "Consultation report"
      def mex_subject             = document_title

      # # E.g. "371531000"
      # def _code = snomed_document_type_code

      # # E.g. 'Report of clinical encounter'
      # def document_type_snomed_title = snomed_document_type_description

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
          request.patient.nhs_number,
          request.patient.born_on.strftime("%Y%m%d"),
          request.patient.family_name
        ].join("_")
      end

      def document_title
        [
          "#{composition_title} for #{request.patient.display_name}",
          "NHS Number: #{request.patient.nhs_number}",
          "seen at #{organisation_name}",
          organisation_ods_code,
          "Version: #{document_version}"
        ].join(", ")
      end

      private

      def config = Renalware.config

      def validate_arguments
        raise Letters::MissingPdfContentError if request.pdf_missing?
        raise MissingSnomedDocumentTypeError if request.document_type_missing?
      end
    end
  end
end
