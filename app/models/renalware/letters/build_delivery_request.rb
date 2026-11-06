module Renalware
  module Letters
    # Maps a Renalware letter (and our configured sender identity) to a plain DeliveryRequest.
    # This is the only place the delivery code's inputs are pulled out of ActiveRecord models and
    # Renalware.config.
    #
    # Each field of the request is resolved by one small method named <part>_<field> (e.g.
    # patient_nhs_number). #call resolves them all up front. #lazy returns an object with the same
    # readers that resolves each field only when first asked for it, which preserves the
    # reads-only-what-it-needs behaviour the FHIR builders have always had.
    class BuildDeliveryRequest
      include Callable

      PARTS = {
        patient: DeliveryRequest::Patient,
        author: DeliveryRequest::Author,
        document: DeliveryRequest::Document,
        sender: DeliveryRequest::Sender
      }.freeze

      attr_reader :letter

      def initialize(letter:, organisation_uuid: nil, itk_organisation_uuid: nil)
        @letter = letter
        @organisation_uuid = organisation_uuid
        @itk_organisation_uuid = itk_organisation_uuid
      end

      # A DeliveryRequest built eagerly from the letter.
      def call
        DeliveryRequest.new(**PARTS.keys.index_with { |part| build(part) })
      end

      def lazy = LazyRequest.new(self)

      def build(part)
        klass = PARTS.fetch(part)
        klass.new(**klass.members.index_with { |field| resolve(part, field) })
      end

      def resolve(part, field) = send(:"#{part}_#{field}")

      # Same readers as a DeliveryRequest, but each field is only read when first used.
      class LazyRequest
        def initialize(builder) = @builder = builder
        def patient  = @patient  ||= Part.new(@builder, :patient)
        def author   = @author   ||= Part.new(@builder, :author)
        def document = @document ||= Part.new(@builder, :document)
        def sender   = @sender   ||= Part.new(@builder, :sender)

        # Validation reads only the archive and topic, not the whole letter (as it always did).
        # The try is because we have a lot of tests that don't stub letter.archive.
        def pdf_missing?
          archive = @builder.letter.try(:archive)
          archive.present? && archive.pdf_content.blank?
        end

        def document_type_missing?
          snomed = @builder.letter.topic&.snomed_document_type
          snomed&.code.blank? || snomed&.title.blank?
        end
      end

      class LazyRequest::Part
        def initialize(builder, part)
          @builder = builder
          @part = part
          @values = {}
        end

        def method_missing(name, *)
          return super unless PARTS.fetch(@part).members.include?(name)

          @values.fetch(name) { @values[name] = @builder.resolve(@part, name) }
        end

        def respond_to_missing?(name, include_private = false)
          PARTS.fetch(@part).members.include?(name) || super
        end
      end

      private

      attr_reader :organisation_uuid, :itk_organisation_uuid

      delegate :patient, :author, :archive, to: :letter

      def config = Renalware.config

      # Patient
      def patient_uuid = patient.secure_id_dashed
      def patient_nhs_number = patient.nhs_number
      def patient_born_on = patient.born_on
      def patient_given_name = patient.given_name
      def patient_family_name = patient.family_name
      def patient_title = patient.title
      def patient_display_name = patient.to_s
      def patient_sex_code = patient.sex&.code
      def patient_telephone = patient.telephone1
      def patient_email = patient.email
      # rubocop:disable-next Naming/PredicateMethod
      def patient_restricted = !patient.confidentiality_normal?

      def patient_address
        address = patient.current_address
        return if address.blank?

        DeliveryRequest::Address.new(
          **DeliveryRequest::Address.members.index_with { |field| address.public_send(field) }
        )
      end

      def patient_local_patient_ids
        [
          patient.local_patient_id,
          patient.local_patient_id_2,
          patient.local_patient_id_3,
          patient.local_patient_id_4
        ].compact_blank.uniq
      end

      # Author
      def author_uuid = author.uuid
      def author_given_name = author.given_name
      def author_family_name = author.family_name
      def author_professional_position = author.professional_position

      # Document
      def document_uuid = letter.uuid
      def document_binary_uuid = archive&.uuid
      def document_approved_at = letter.approved_at
      def document_pdf_content = archive&.pdf_content
      def document_type_snomed_code = snomed_document_type&.code
      def document_type_snomed_title = snomed_document_type&.title
      def snomed_document_type = letter.topic&.snomed_document_type

      # Sender
      def sender_uuid = organisation_uuid || config.mesh_organisation_uuid
      def sender_itk_uuid = itk_organisation_uuid || config.mesh_itk_organisation_uuid
      def sender_ods_code = config.mesh_organisation_ods_code
      def sender_name = config.mesh_organisation_name
      def sender_phone = config.mesh_organisation_phone
      def sender_email = config.mesh_organisation_email
      def sender_mailbox_id = config.mesh_mailbox_id
      def sender_care_setting_snomed_code = config.mesh_care_setting_snomed_code
      def sender_care_setting_description = config.mesh_care_setting_description
    end
  end
end
