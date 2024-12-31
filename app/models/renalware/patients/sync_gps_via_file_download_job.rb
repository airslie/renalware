module Renalware
  module Patients
    class SyncGpsViaFileDownloadJob < ApplicationJob
      ODS_DOWNLOADABLES = {
        primary_care_physicians: {
          url: "https://files.digital.nhs.uk/assets/ods/current/egpcur.zip",
          filename: "egpcur.zip"
        },
        practice_memberships: {
          url: "https://files.digital.nhs.uk/assets/ods/current/epracmem.zip",
          filename: "epracmem.zip"
        }
      }.freeze

      # Do not retry this job
      discard_on(StandardError) do |_job, exception|
        Renalware::Engine.exception_notifier.notify(exception)
        Rails.logger.error exception
      end

      # Now we have brought practices up to date, update GPs and their membership in practices.
      # Download the relevant zip file, save it as a Feeds::File (the zip file will be copied to
      # the uploads dir) and kick off a sync job to import the data, which it does by unzipping
      # the file, extracting the csv and using a PG function to upsert the contents.
      # Note we cannot reliably use an async job here as the order of execution of the 3 updates -
      # practices, gps, practice memberships - is strict.
      def perform
        ODS_DOWNLOADABLES.each do |type, options|
          # Download the ODS file to a temporary location - must be /tmp dir on linux
          # in order for PG to have access - hence using Tempfile
          tmp_file = Pathname(Tempfile.new(options[:filename]))
          `wget -O #{tmp_file} #{options[:url]}`
          file = create_feed_file(type, tmp_file)
          Renalware::Feeds::Files::ImportJobFactory.job_class_for(file.file_type).perform_now(file)
        end
      end

      private

      def create_feed_file(type, tmp_file)
        Renalware::Feeds::Files::CreateFeedFile.call(
          uploaded_file: tmp_file,
          file_type: Renalware::Feeds::FileType.find_by(name: type),
          user: Renalware::SystemUser.find
        )
      end
    end
  end
end
