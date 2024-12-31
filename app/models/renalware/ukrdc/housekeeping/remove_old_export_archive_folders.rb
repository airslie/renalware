module Renalware
  module UKRDC
    module Housekeeping
      # Responsible for cleaning up old archive folders that are created each time the
      # ukrdc:export task has run. Each archive folder's name has a batch number in it which is the
      # id of the UKRDC::Batch model created at the start of each export. We can find the
      # folders to remove by extracting the batch number from the folder name and deleting the
      # folder if that batch is no longer 'recent'.
      # Called from a housekeeping rake task.
      class RemoveOldExportArchiveFolders
        def self.call
          new.call
        end

        def call
          remove_old_archives
        end

        private

        class ArchiveFolder
          pattr_initialize :folder

          # Returns the integer batch number from the folder name
          # e.g. 13 from /var/ukrdc/archive/000013_20190827081107620
          def batch_number
            matches = folder.match(%r(\/(\d{6})_))
            return unless matches

            matches[1].to_i
          end
        end

        def remove_old_archives
          log "Remove old archives"
          log "Keeping archived batches #{batch_numbers_to_keep.join(', ')}"

          Dir.glob(glob_pattern).each do |folder|
            archive_folder = ArchiveFolder.new(folder)
            next unless archive_folder.batch_number

            if remove_folder?(archive_folder)
              log "Removing #{folder}"
              FileUtils.rm_rf folder
            end
          end
        end

        # Pattern to use to find batch-numbered folders in the archive directory
        def glob_pattern
          archive_path.join("??????_*")
        end

        def archive_path
          Pathname(Renalware.config.ukrdc_working_path).join("archive")
        end

        def number_of_archived_folders_to_keep
          Renalware.config.ukrdc_number_of_archived_folders_to_keep.to_i
        end

        # Returns the ids of a few of the most recent Batch rows (ie the batch number) that
        # we should not delete - these being the most recent ones we want to stick around in case we
        # need to inspect what was sent.
        def batch_numbers_to_keep
          @batch_numbers_to_keep ||= begin
            Batch
              .limit(number_of_archived_folders_to_keep)
              .order(created_at: :desc)
              .pluck(:id)
          end
        end

        def remove_folder?(archive_folder)
          !batch_numbers_to_keep.include?(archive_folder.batch_number)
        end

        def log(msg)
          Rails.logger.info(" #{msg}")
        end
      end
    end
  end
end
