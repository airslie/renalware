module Renalware
  module Letters
    # Everything needed to deliver one letter electronically to a patient's GP, as plain,
    # immutable values: no ActiveRecord, no Renalware.config, no database.
    #
    # This is the boundary between Renalware (which knows about letters, patients and users) and
    # the delivery code (FHIR payload building, MESH). Renalware builds one with
    # BuildDeliveryRequest; a different sender (e.g. Relay, from an incoming HL7 message) can
    # build one directly. Keep it free of anything Renalware-specific.
    #
    # NB the nested types are assigned as DeliveryRequest::X (not inside a Data.define block,
    # where the constants would leak into Renalware::Letters and clash with e.g. Letters::Patient).
    DeliveryRequest = Data.define(:patient, :author, :document, :sender) do
      def pdf_missing? = document.pdf_content.blank?

      def document_type_missing?
        document.type_snomed_code.blank? || document.type_snomed_title.blank?
      end
    end

    # `restricted` patients must not be sent electronically; carried through so the message can
    # state the confidentiality level.
    DeliveryRequest::Patient = Data.define(
      :uuid, :nhs_number, :born_on, :given_name, :family_name, :title, :display_name,
      :sex_code, :telephone, :email, :restricted, :address, :local_patient_ids
    )

    DeliveryRequest::Address = Data.define(
      :street_1, :street_2, :street_3, :town, :county, :postcode
    )

    DeliveryRequest::Author = Data.define(
      :uuid, :given_name, :family_name, :professional_position
    )

    # The letter itself: its identity, the PDF, and how it is classified.
    DeliveryRequest::Document = Data.define(
      :uuid, :binary_uuid, :approved_at, :pdf_content, :type_snomed_code, :type_snomed_title
    )

    # The sending organisation (hospital / department).
    DeliveryRequest::Sender = Data.define(
      :uuid, :itk_uuid, :ods_code, :name, :phone, :email, :mailbox_id,
      :care_setting_snomed_code, :care_setting_description
    )
  end
end
