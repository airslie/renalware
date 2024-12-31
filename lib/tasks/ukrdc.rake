require "fileutils"

# Note you can print out the help for this task and others with `rake -D`
namespace :ukrdc do
  desc <<-DESC
    Creates a folder of UKRDC XML files with any changes to PV + RR patients since their last export
    Notes:
      1. Running the rake task updates the sent_to_ukrdc_at for each patient exported.
         If you don't want to do this you may need to edit this task to wrap the code in a
         transaction you can optionally roll back.
     2: If testing this inside the renalware-core gem, you will need to append app: e.g.
        app:ukrdc:export ...

    Example usage
      1. To get all RR and PKB patients with who have changed
         since the last time they were sent, or have not been sent to the UKRDC yet:

         bundle exec rake ukrdc:export

      2. To get all RR and PKB patients who have changed since a certain date:

         bundle exec rake ukrdc:export changed_since="2018-02-23"

      3. To get only certain RR and PKB patients (by their id eg ids 1 and 2) with changes since
         a certain date:

         bundle exec rake ukrdc:export changed_since=2018-02-23 patient_ids=1,2
  DESC
  task export: :environment do |_task, _args|
    logger           = ActiveSupport::TaggedLogging.new(Logger.new($stdout))
    logger.level     = Logger::INFO
    Rails.logger     = logger

    PROFILE = nil
    if PROFILE
      require "ruby-prof"
      RubyProf.start
    end
    # Renalware::UKRDC::TreatmentTimeline::GenerateTreatments.call
    Renalware::UKRDC::CreateEncryptedPatientXmlFiles.new(
      changed_since: ENV["changed_since"],
      patient_ids: ENV.fetch("patient_ids", "").split(",").map(&:to_i),
      force_send: ENV["force_send"] == "true"
    ).call

    if PROFILE
      result = RubyProf.stop
      pretty = RubyProf::FlatPrinter.new(result)
      pretty.print($stdout)
      # printer.print(STDOUT, {})
      # printer = RubyProf::GraphPrinter.new(result)
      # printer = RubyProf::GraphHtmlPrinter.new(result)
      # printer.print(STDOUT, min_percent: 5)
    end
  end

  desc "Regenerates the ukrdc_treatments table ready for exporting to UKRDC in another task"
  task generate_treatments: :environment do
    logger           = ActiveSupport::TaggedLogging.new(Logger.new($stdout))
    logger.level     = Logger::INFO
    Rails.logger     = logger
    Renalware::UKRDC::TreatmentTimeline::GenerateTreatments.call
  end

  task housekeeping: :environment do
    logger           = ActiveSupport::TaggedLogging.new(Logger.new($stdout))
    logger.level     = Logger::INFO
    Rails.logger     = logger
    logger.info "UKRDC housekeeping"
    Renalware::UKRDC::Housekeeping::RemoveOldExportArchiveFolders.call
    Renalware::UKRDC::Housekeeping::RemoveStaleFiles.call
  end

  task import: :environment do
    # Import patient questionnaire data from SFTP'ed UKRDC XML files
    logger           = ActiveSupport::TaggedLogging.new(Logger.new($stdout))
    logger.level     = Logger::INFO
    Rails.logger     = logger

    Renalware::UKRDC::Incoming::ImportSurveys.new(logger: logger).call
  end

  desc "SFTP waiting files in the outgoing folder to the UKRDC SFTP server"
  task transfer_outgoing_files: :environment do
    logger           = ActiveSupport::TaggedLogging.new(Logger.new($stdout))
    logger.level     = Logger::INFO
    Rails.logger     = logger

    # Using perform_now here because the delayed_job retry mechanism is a bit odd
    # (there seems to be a retry at the delayed_job level and at the ActiveJob level..) anyway
    # we do not to retry at all so making it synchronous.
    Renalware::UKRDC::Outgoing::TransferFilesJob.perform_now
  end
end
