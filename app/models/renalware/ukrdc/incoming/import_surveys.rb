module Renalware
  module UKRDC
    module Incoming
      class ImportSurveys
        pattr_initialize [:paths, :logger]
        attr_reader :batch_uuid

        def initialize(paths: nil, logger: nil)
          @paths = paths || Renalware::UKRDC::Incoming::Paths.new
          @logger = logger || Rails.logger
          @batch_uuid = SecureRandom.uuid # to group logging output
        end

        def call
          Incoming::FileList.new(paths: paths).each_file do |filepath|
            if already_imported?(filepath)
              logger.info "Skipping: #{filepath} already successfully imported"
              FileUtils.mv filepath, paths.archive.join(filepath.basename)
              next
            end
            logger.info "Processing: #{filepath}"
            import_surveys_from_file(filepath)
          end
        rescue StandardError => e
          Renalware::Engine.exception_notifier.notify(e)
          raise e
        end

        private

        # If a file arrives that we have already imported successfully then skip it.
        # This assumes filenames are unique across time, which they should be.
        # Note we match on the whole file path, so if the location of the folder changes
        # and we are presented with familiar files, then they will be imported again. Its unlikely
        # those two things will happen together though.
        def already_imported?(filepath)
          TransmissionLog.exists?(file_path: filepath.to_s, status: :imported)
        end

        # Import all surveys (they will be for the same patient) in the XML file.
        # Note that #with_logging yields a block that will catch and save any error to
        # ukrdc_transmission_logs
        def import_surveys_from_file(file)
          # Important to create the log before we do anything that might cause an error
          # eg parse the xml etc.
          TransmissionLog.with_logging(request_uuid: batch_uuid, **log_options(file)) do |log|
            doc = XmlDocument.new(file)
            patient = find_patient(doc.nhs_number)
            log.update!(patient_id: patient.id)
            doc.surveys.each do |survey_hash|
              import_survey(survey_hash, patient)
            end
            log.update!(status: :imported)
          end
        rescue StandardError
          # noop - errors have been logged inside with_logging
        ensure
          FileUtils.mv file, paths.archive.join(file.basename)
        end

        def import_survey(survey_hash, patient)
          ImportSurvey.new(
            patient: patient,
            survey_hash: survey_hash
          ).call
        end

        def find_patient(nhs_number)
          Renalware::Patient.find_by!(nhs_number: nhs_number)
        end

        # rubocop:disable Style/RescueModifier
        def log_options(file)
          {
            status: :undefined,
            file_path: file.to_s,
            direction: :in,
            payload: (File.read(file) rescue nil)
          }
        end
        # rubocop:enable Style/RescueModifier
      end
    end
  end
end
