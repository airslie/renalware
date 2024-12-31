require "fileutils"

module Renalware
  module Feeds
    module Files
      class CreateFeedFile
        include Virtus.model
        include Callable

        attribute :uploaded_file, Pathname
        attribute :file_type, Renalware::Feeds::FileType
        attribute :user, Renalware::User

        def call
          copy_uploaded_file_to_uploads_dir
          create_feed_file
        end

        private

        def copy_uploaded_file_to_uploads_dir
          FileUtils.cp(uploaded_file, new_filepath)
        end

        def new_filepath
          @new_filename ||= begin
            name = "#{SecureRandom.uuid}_#{uploaded_file.basename}".truncate(254)
            ::File.join(uploads_dir, name)
          end
        end

        def uploads_dir
          Rails.root.join("tmp/uploads").tap do |uploads_path|
            warn "using upload path #{uploads_path}" if Rails.env.development?
            FileUtils.mkdir_p(uploads_path)
          end
        end

        def create_feed_file
          Renalware::Feeds::File.build(
            location: new_filepath,
            file_type: file_type,
            user: user
          ).tap(&:save!)
        end
      end
    end
  end
end
