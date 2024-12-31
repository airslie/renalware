module Renalware
  module Patients
    #
    # An Attachment is file of some kind linked to a patient.
    # How and where the file is stored depends on the #store_file_externally boolean on
    # attachment#attachment_type.
    #
    # attachment_type#store_file_externally == true
    #   we validate that the external_location field is present, as this is assumed to be the path
    #   to the file on a network share for instance.
    #   We don't care whether it is a real path or where it is - the user enters it manually.
    #
    # attachment_type#store_file_externally == false
    #   we validate that the ActiveStorage #file attachment is uploaded (and not too big).
    #
    class Attachment < ApplicationRecord
      include Accountable
      include RansackAll

      acts_as_paranoid
      belongs_to :patient, touch: true
      belongs_to :attachment_type, class_name: "Renalware::Patients::AttachmentType"
      has_one_attached :file

      validates :patient, presence: true
      validates :attachment_type_id, presence: true
      validates :name, presence: true
      validates :external_location, presence: { if: -> { attachment_type&.store_file_externally } }
      validate :validate_uploaded_file_size
      validate :validate_presence_of_file_if_attachment_type_indicates_it_should_be_uploaded

      private

      def validate_uploaded_file_size
        max = Renalware.config.max_file_upload_size
        if file.attached? && file.blob.byte_size > max
          file.purge if file.persisted?
          errors.add(:file, "Sorry, the file is too large. The maximum is #{max} bytes.")
        end
      end

      def validate_presence_of_file_if_attachment_type_indicates_it_should_be_uploaded
        return if attachment_type.blank?

        if !file.attached? && attachment_type.store_file_internally?
          errors.add(:file, "Please specify a file to upload")
        end
      end
    end
  end
end
