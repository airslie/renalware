module Relay
  module GPConnect
    # Everything needed to deliver one letter electronically to a patient's GP, as plain,
    # immutable values: no ActiveRecord, no global configuration, no database.
    #
    # This is the boundary between the application that owns the letters (Renalware, or Relay
    # receiving an HL7 message) and the code in this gem. The application builds one of these and
    # hands it to FHIR::BuildPayload; it never needs to know how the message is made.
    #
    # NB the nested types are assigned as DeliveryRequest::X (not inside a Data.define block,
    # where the constants would leak into the enclosing module).
    DeliveryRequest = Data.define(:patient, :author, :document, :sender, :routing) do
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

    # The letter itself: its identity, the PDF, and how it is classified and titled.
    # composition_title is the human title of this kind of document (e.g. "Consultation report",
    # "Discharge summary"); version is the document version being sent.
    DeliveryRequest::Document = Data.define(
      :uuid, :binary_uuid, :approved_at, :pdf_content, :type_snomed_code, :type_snomed_title,
      :composition_title, :version
    )

    # Where to deliver. A blank recipient_mailbox_id means "let MESH auto-route to the patient's
    # GP using their demographics"; a value means send directly to that mailbox.
    DeliveryRequest::Routing = Data.define(:recipient_mailbox_id)

    # The sending organisation (hospital / department).
    DeliveryRequest::Sender = Data.define(
      :uuid, :itk_uuid, :ods_code, :name, :phone, :email, :mailbox_id,
      :care_setting_snomed_code, :care_setting_description
    )
  end
end
