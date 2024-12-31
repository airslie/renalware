module Renalware
  module UKRDC
    module Housekeeping
      class RemoveStaleFiles
        def self.call
          new.call
        end

        def call
          return unless Renalware.config.ukrdc_remove_stale_outgoing_files

          remove_stale_outgoing_files
        end

        private

        class OutgoingXmlFile
          pattr_initialize :filename

          # Returns the integer batch number from the file name
          # e.g. 13 from /var/ukrdc/outgoing/RJZ_000040_1234606005.gpg
          def batch_number
            matches = filename.match(/\w*_(\d{6})_/)
            return unless matches

            matches[1].to_i
          end
        end

        def remove_stale_outgoing_files
          log "Remove stale outgoing files"
          log "Keeping files in batches #{batch_numbers_to_keep.join(', ')}"

          Dir.glob(glob_pattern).each do |filename|
            FileUtils.rm filename if remove_file?(filename)
          end
        end

        # Pattern to use to find batch-numbered files in the outgoing directory
        def glob_pattern
          outgoing_path.join("*.gpg")
        end

        def outgoing_path
          Pathname(Renalware.config.ukrdc_working_path).join("outgoing")
        end

        def number_of_batches_to_keep
          Renalware.config.ukrdc_number_of_archived_folders_to_keep.to_i
        end

        # Returns the ids of a few of the most recent Batch rows (ie the batch number) that
        # we should not delete - these being the most recent ones
        def batch_numbers_to_keep
          @batch_numbers_to_keep ||= begin
            Batch
              .limit(number_of_batches_to_keep)
              .order(created_at: :desc)
              .pluck(:id)
          end
        end

        def remove_file?(filename)
          !batch_numbers_to_keep.include?(
            OutgoingXmlFile.new(filename).batch_number
          )
        end

        def log(msg)
          Rails.logger.info(" #{msg}")
        end
      end
    end
  end
end
