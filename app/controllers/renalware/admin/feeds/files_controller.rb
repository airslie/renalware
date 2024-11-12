# frozen_string_literal: true

require "fileutils"

module Renalware
  module Admin
    module Feeds
      class FilesController < BaseController
        include Renalware::Concerns::Pageable

        def index
          authorize files
          render locals: {
            files: files,
            uploaded_file: Renalware::Feeds::Files::FileUploadForm.new
          }
        end

        def create
          authorize Renalware::Feeds::File, :create?
          form = Renalware::Feeds::Files::FileUploadForm.new(file_upload_params)

          if form.valid?
            file = Renalware::Feeds::Files::CreateFeedFile.call(
              uploaded_file: Pathname.new(form.file.path),
              file_type: Renalware::Feeds::FileType.find(form.file_type_id),
              user: current_user
            )
            Renalware::Feeds::Files::EnqueueFileForBackgroundProcessing.call(file)
            redirect_to(
              admin_feeds_files_path,
              notice: "File #{form.file.original_filename} queued for processing"
            )
          else
            render :index, locals: { files: files, uploaded_file: form }
          end
        end

        private

        def files
          @files ||= Renalware::Feeds::File
            .ordered
            .includes(:file_type, :created_by)
            .page(page)
            .per(per_page)
        end

        def file_upload_params
          params.require(:file_upload).permit(:file, :file_type_id)
        end
      end
    end
  end
end
