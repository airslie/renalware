module Renalware
  module Feeds
    module Files
      module PracticeMemberships
        class ImportJob < ApplicationJob
          include StringLogging
          include Feeds::Job
          FILE_TO_EXTRACT_FROM_ARCHIVE = /epracmem.csv/

          # TODO: refactor
          def perform(file)
            logging_to_stringio(strio = StringIO.new)
            log "Before upload there are #{practice_membership_count} practice memberships"
            file.update!(status: :processing, attempts: file.attempts + 1)
            status = :success
            elapsed_ms = Benchmark.ms { process_archive(file.location) }
            log "After upload there are #{practice_membership_count} practice memberships"
          rescue StandardError => e
            Rails.logger.error(formatted_exception(e))
            status = :failure
            raise e
          ensure
            file.update!(status: status, result: strio.string, time_taken: elapsed_ms)
          end

          private

          def process_archive(location)
            ZipArchive.new(location).unzip do |files|
              csv_path = find_file_in(files, FILE_TO_EXTRACT_FROM_ARCHIVE)
              PracticeMemberships::ImportCSV.new(csv_path).call
            end
          end

          def practice_membership_count
            Patients::PracticeMembership.count
          end
        end
      end
    end
  end
end
