require "base64"

# rubocop:disable Metrics/AbcSize
module Renalware
  module Feeds
    # Given a Letters:::Letter, generates an HL7 MDMT T02 message
    # Example
    # MSH|^~\&|Renalware|MSE|||20210920180000||MDM^T02|RW0000000001|RW0000000001|P|2.3.1
    # EVN|T02|20210920180000
    # PID||9999999999^^^NHS|12345^^^RAJ01||Jones^C^Patricia^^Ms||19700101|F|
    # TXA|1|CL|ED|201508010900|^Foster^John^Harry^^Dr||201508010920|201508010930 \
    #   ||||123||||RAJ01_12345_JONES_202109020_123.pdf|AU
    # OBX|1|ED|||^TODO^PDF^Base64^BERi0xLjMKJeTjz9IKNSI (more bytes...)||||||
    class HL7DocumentMessageBuilder
      include Callable

      delegate :patient,
               :external_document_type_code,
               :external_document_type_description,
               :author,
               :deleted_at,
               to: :renderable

      # Returns the content of a 'blank' deleted_document.(pdf|rtf) document in app/assets.
      # This is used when the letter has been deleted, and we want to send a 'blank' PDF/RTF file
      # (actually it just contains the words 'Document deleted') in the HL7 message to help indicate
      # that the document has been deleted.
      def self.blank_file_to_send_when_document_has_been_deleted
        format = Renalware.config.feeds_outgoing_documents_letter_format # :pdf or :rtf
        file_path = Renalware::Engine.root.join("app/assets/#{format}/deleted_document.#{format}")
        raise "Missing file #{file_path}" unless ::File.exist?(file_path)

        ::File.binread(file_path)
      end

      def initialize(renderable:, document:)
        @renderable = renderable
        @document = document
      end

      def call
        @msg = HL7::Message.new
        msg << msh
        msg << evn
        msg << pid
        msg << pv1
        msg << txa
        msg << obx
        msg
      end

      private

      attr_reader :renderable, :document, :msg

      def deleted? = deleted_at.present?

      # E.g. MSH|^~\&|Renalware|MSE|||20210920180000||MDM^T02|RW0000000001|P|2.3.1
      def msh
        seg = HL7::Message::Segment::MSH.new
        seg.enc_chars = "^~\\&"
        seg.sending_app = "Renalware"
        seg.sending_facility = "MSE"
        # message_control_id is the correct place for our external_id - however, we accidentally
        # used the processing_id field for this in the past, so we populate both now.
        seg.message_control_id = external_id
        seg.processing_id = external_id
        seg.message_type = "MDM^T02"
        seg.time = Time.zone.now
        seg.version_id = Rails.env.production? ? "P" : "U"
        seg.seq = Renalware::VERSION
        seg
      end

      def evn
        seg = HL7::Message::Segment::EVN.new
        seg.type_code = "T02"
        seg.recorded_date = renderable.try(:approved_at) || renderable.created_at
        seg
      end

      def pv1
        seg = HL7::Message::Segment::PV1.new
        seg.patient_class = "O" # Always send as outpatient
        seg.hospital_service = Renalware.config.feeds_outgoing_documents_hospital_service
        if renderable.respond_to?(:visit_number)
          seg.visit_number = renderable.visit_number
        end
        if renderable.respond_to?(:clinic_code)
          seg.assigned_location = renderable.clinic_code
        end
        seg
      end

      # E.g. PID||9999999999^^^NHS|12345^^^RAJ01||Jones^C^Patricia^^Ms||19700101|F|
      def pid
        seg = HL7::Message::Segment::PID.new
        seg.patient_id = "#{patient.nhs_number}^^^NHS"

        seg.patient_id_list = patient.hospital_identifiers.all.map do |assigning_auth, id|
          # At MSE the hosp identifier key will be eg BAS (hospital_centre.abbrev) but we need
          # to map to eg RAJ01 (hospital_centre.code) and use that when building the PID.
          # We could so this in Mirth but doing here for now by looking at the hospital_centres
          # table.
          auth = Hospitals::Centre.find_by(abbrev: assigning_auth)&.code || assigning_auth
          "#{id}^^^#{auth}"
        end.join("~")
        seg.patient_name = "#{patient.family_name}^^#{patient.given_name}^^#{patient.title}"
        seg.patient_dob = patient.born_on&.strftime("%Y%m%d")
        seg
      end

      # TXA|1|CL^Clinic Letter|ED^Electronic Document|201508010900| \
      #  ^Foster^John^Harry^^Dr||201508010920|201508010930||||123|||| \
      #  RAJ01_12345_JONES_202109020_123.pdf|AU
      # rubocop:disable Metrics/MethodLength
      def txa
        approved_at = renderable.approved_at.strftime("%Y%m%d%H%M")
        seg = HL7::Message::Segment::TXA.new
        seg.document_type = "#{external_document_type_code}^#{external_document_type_description}"
        seg.document_content_presentation = "ED^Electronic Document"
        seg.activity_date_time = approved_at
        # primary_activity_provider_code is the author
        seg.primary_activity_provider_code = <<-AUTHOR.squish
          #{author.gmc_code}^#{author.family_name}^#{author.given_name}
        AUTHOR

        # TXA.6 Origination timestamp - the date the letter was Approved ie became effectively
        # 'sent' and therefore immutable
        seg.origination_date_time = approved_at
        seg.unique_document_number = if Renalware.config.feeds_outgoing_documents_use_guids
                                       renderable.uuid
                                     else
                                       renderable.id
                                     end
        seg.unique_document_file_name = filename
        seg.document_completion_status = deleted? ? "CA" : "AU"
        seg
      end
      # rubocop:enable Metrics/MethodLength

      # eg "HOSP1_111_HOSP2_222_HOSP3_333_surname_dob_letter_id.pdf"
      def filename
        # A host Rails app might have overwritten these custom filename class
        # but we do not care about that here.
        if renderable_type.letter?
          Feeds::LetterFilename.new(renderable).to_s
        elsif renderable_type.event?
          Feeds::EventFilename.new(renderable).to_s
        else
          raise ArgumentError, "cannot render #{renderable_type}"
        end
      end

      # OBX|1|ED|||^TODO^PDF^Base64^BERi0xLjMKJeTjz9IKNSI (more bytes...)||||||
      def obx
        base64 = base64_encoded_content

        seg = HL7::Message::Segment::OBX.new
        seg.set_id = "1"
        seg.value_type = "ED"
        seg.observation_value = "^TEXT^#{file_format.to_s.upcase}^Base64^#{base64}"
        seg
      end

      # Could be a uuid (outgoing_document.external_id) or an integer id (outgoing_document.id).
      # If it is an integer we convert to our usual external_id format "RW0000000123"
      # However we are migrating to uuids so we should be able to remove the integer handling
      # eventually.
      def external_id
        if Renalware.config.feeds_outgoing_documents_use_guids
          document.external_uuid
        else
          document.id && ["RW", document.id.to_s.rjust(10, "0")].join
        end
      end

      def base64_encoded_content
        content = if deleted?
                    self.class.blank_file_to_send_when_document_has_been_deleted
                  elsif renderable_type.letter?
                    Letters::RendererFactory.renderer_for(renderable, file_format).call
                  elsif renderable_type.event?
                    Renalware::Events::EventPdf.call(renderable)
                  end
        Base64.strict_encode64(content)
      end

      # :pdf or :rtf
      # Events are always :pdf
      # Letters can be :pdf or :rtf depending on the config
      def file_format
        renderable_type.letter? ? Renalware.config.feeds_outgoing_documents_letter_format : :pdf
      end

      def renderable_type
        @renderable_type ||= begin
          klass = renderable.class.name
          type = if klass.at("Letters::")
                   "letter"
                 elsif klass.at("Events::")
                   "event"
                 else
                   raise ArgumentError, "cannot render #{klass}"
                 end
          ActiveSupport::StringInquirer.new(type)
        end
      end
    end
  end
end
# rubocop:enable Metrics/AbcSize
