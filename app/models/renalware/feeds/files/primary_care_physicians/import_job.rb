module Renalware
  module Feeds
    module Files
      module PrimaryCarePhysicians
        class ImportJob < ApplicationJob
          include StringLogging
          include Feeds::Job

          FILE_TO_EXTRACT_FROM_ARCHIVE = /^egpcur.csv$/

          def perform(file)
            logging_to_stringio(strio = StringIO.new)
            log "PrimaryCarePhysician count before update: #{primary_care_physician_count}"
            file.update!(status: :processing, attempts: file.attempts + 1)
            status = :success
            elapsed_ms = Benchmark.ms { process_archive(file.location) }
            log "PrimaryCarePhysician count after update: #{primary_care_physician_count}"
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
              PrimaryCarePhysicians::ImportCSV.new(csv_path).call
            end
          end

          def primary_care_physician_count
            Renalware::Patients::PrimaryCarePhysician.count
          end
        end
      end
    end
  end
end
