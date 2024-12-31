require "net/sftp"

module Renalware
  module UKRDC
    module Outgoing
      # ActiveJob to SFTP *.gpg UKRDC files queued in the outgoing folder to the UKRDC.
      #
      # For each file in the glob, we attempt to find and update the corresponding TransmissionLog.
      #
      # In order to test this implementation in development, start a local SFTP server using
      #   docker run -p 22:2222 -d atmoz/sftp foo:pass:::upload
      # and remember you need to copy files into the remote 'upload' folder and so need to set
      #   UKRDC_SFTP_REMOTE_PATH="upload"
      #   UKRDC_SFTP_PORT="2222"
      # e.g. in a .env file
      class TransferFilesJob < ApplicationJob
        def perform
          System::APILog.with_log("SFTP UKRDC") do |apilog|
            Net::SFTP.start(*sftp_options) do |sftp|
              outgoing_glob.each do |file|
                file = QueuedFile.new(file)
                sftp.upload!(file.to_s, Paths.remote.join(file.basename))
                apilog.records_added += 1
                update_matching_transmission_log_entry(file.basename_without_extension)
              end
              remove_local_outgoing_files
            end
          end
        end

        private

        class QueuedFile
          delegate :basename, :to_s, to: :@file_path

          def initialize(file_path)
            @file_path = Pathname(file_path)
          end

          def basename_without_extension = basename.to_s.gsub(".gpg", "")
        end

        class Paths
          def self.local
            Pathname(Renalware.config.ukrdc_working_path).join("outgoing")
          end

          # This will be 'upload' if using test docker image but likely '' if targeting UKRDC
          def self.remote
            Pathname(Renalware.config.ukrdc_sftp_remote_path)
          end
        end

        # Note if credentials invalid, non_interactive: true means Net::SFTP will raise an error
        # rather that prompt for a password (in a possibly non-existent pty..)
        def sftp_options
          [
            Renalware.config.ukrdc_sftp_host,
            Renalware.config.ukrdc_sftp_user,
            {
              password: Renalware.config.ukrdc_sftp_password,
              port: Renalware.config.ukrdc_sftp_port,
              non_interactive: true
            }
          ]
        end

        def update_matching_transmission_log_entry(filename)
          transmission_log_matching_filename(filename)
            &.update!(sent_at: Time.zone.now, status: :sftped)
        end

        def transmission_log_matching_filename(filename)
          TransmissionLog.where(
            "file_path ilike ?",
            "%#{filename}%"
          ).first
        end

        def remove_local_outgoing_files
          FileUtils.rm_r outgoing_glob
        end

        def outgoing_glob
          Dir.glob(Paths.local.join("*.*"))
        end
      end
    end
  end
end
