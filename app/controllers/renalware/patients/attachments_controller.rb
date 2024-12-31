module Renalware
  module Patients
    class AttachmentsController < BaseController
      include Pagy::Backend
      include Renalware::Concerns::PatientVisibility

      def index
        pagy, attachments = pagy(self.attachments)
        authorize attachments

        render locals: {
          patient: patient,
          attachments: CollectionPresenter.new(attachments, AttachmentPresenter),
          search: query.search,
          pagy: pagy
        }
      end

      # If the attachment has an uploaded #file (i.e. it is not stored externally but has been
      # uploaded via ActiveStorage) then return a url to the stored file so it can be opened in
      # a new window. It if it has a content type the browser recognises it will display it
      # directly - otherwise the browser will download it.
      def show
        attachment = find_and_authorize_attachment
        if attachment.file.attached?
          url = Rails.application.routes.url_helpers.rails_blob_url(
            attachment.file,
            only_path: true
          )
          redirect_to(url)
        end
      end

      def new
        attachment = patient.attachments.build
        authorize attachment
        render locals: { attachment: attachment }
      end

      def edit
        render_edit(find_and_authorize_attachment)
      end

      def create
        attachment = patient.attachments.build(attachment_params)
        discard_uploaded_file_if_attachment_type_suggests_external_storage(attachment)

        authorize attachment
        if attachment.save_by(current_user)
          redirect_to patient_attachments_path(patient)
        else
          render_new(attachment)
        end
      end

      def update
        attachment = find_and_authorize_attachment
        if attachment.update(attachment_params)
          redirect_to patient_attachments_path
        else
          render_edit(attachment)
        end
      end

      # Rather than calling #destroy on the record, we manually update the
      # deleted_at column so the record is hidden (soft deleted). Of course
      # acts_as_paranoid would have done this for us on #destroy, but
      # activestorage would also delete the underlying attachment and blob, which we
      # do not want as it defeats the point of a soft-delete! (At the time of writing activestorage
      # does not have an option to skip purging after a delete).
      # The downside of this approach is that no delete callbacks will be triggered.
      def destroy
        find_and_authorize_attachment.update_by(current_user, deleted_at: Time.zone.now)
        redirect_to patient_attachments_path
      end

      private

      # The user may have selected the file to upload, then changed the attachment_type to one that
      # has store_file_externally = true, thus hiding the file input, but the file still gets sent.
      def discard_uploaded_file_if_attachment_type_suggests_external_storage(attachment)
        if attachment.file.attached? && attachment.attachment_type&.store_file_externally?
          attachment.file = nil
        end
      end

      def query
        @query ||= AttachmentQuery.new(patient: patient, params: params[:q])
      end

      def attachments
        @attachments ||= query
          .call
          .includes(:attachment_type, file_attachment: :blob)
      end

      def find_and_authorize_attachment
        patient.attachments.find(params[:id]).tap { |attachment| authorize(attachment) }
      end

      def render_new(attachment)
        render :new, locals: { attachment: attachment }
      end

      def render_edit(attachment)
        render :edit, locals: { attachment: attachment }
      end

      def attachment_params
        params
          .require(:patients_attachment)
          .permit(
            :attachment_type_id,
            :name,
            :description,
            :document_date,
            :file,
            :external_location
          )
      end
    end
  end
end
