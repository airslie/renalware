module Renalware
  module UKRDC
    class Paths
      attr_reader :timestamp, :batch_number, :working_path

      def initialize(batch_number:, working_path:, timestamp: nil)
        raise(ArgumentError, "Invalid working_path") if working_path.blank?

        @timestamp = timestamp
        @batch_number = batch_number
        @timestamp ||= Time.zone.now.strftime("%Y%m%d%H%M%S%L")
        @working_path = Pathname(working_path)
        create_folders
      end

      def archive_folder
        @archive_folder ||= working_path.join("archive")
      end

      # Name for the symlink to the latest archive folder
      def latest_archive_symlink_name
        @latest_archive_symlink_name ||= archive_folder.join("latest")
      end

      def outgoing_folder
        @outgoing_folder ||= working_path.join("outgoing")
      end

      def timestamped_folder
        @timestamped_folder ||= archive_folder.join("#{batch_number}_#{timestamp}")
      end

      def timestamped_xml_folder
        @timestamped_xml_folder ||= timestamped_folder.join("xml")
      end

      def timestamped_encrypted_folder
        @timestamped_encrypted_folder ||= timestamped_folder.join("encrypted")
      end

      def create_symlink_to_latest_timestamped_folder_so_it_is_easier_to_eyeball
        if File.exist?(latest_archive_symlink_name)
          FileUtils.rm(latest_archive_symlink_name)
        end
        FileUtils.ln_sf(timestamped_folder, latest_archive_symlink_name)
      end

      def create_folders
        FileUtils.mkdir_p timestamped_xml_folder
        FileUtils.mkdir_p timestamped_encrypted_folder
        FileUtils.mkdir_p outgoing_folder
      end
    end
  end
end
