require "gpg_encrypt_folder"

module Renalware
  module UKRDC
    # Using a working folder with a timestamp name, find matching patients and for each, generate
    # an XML file (see UKRDC Schema) containing changes since the last time we sent the UKRDC data
    # about them. Encrypt the xml files and copy to an outgoing folder
    # which might for example be a symlink to an outgoing folder in /media/ukrdc which in turn
    # is mount on a remote share for example on an SFTP server.
    class CreateEncryptedPatientXmlFiles
      attr_reader(
        :patient_ids,
        :changed_since,
        :logger,
        :timestamp,
        :batch,
        :summary,
        :force_send
      )

      def initialize(changed_since: nil, patient_ids: nil, logger: nil, force_send: false)
        @changed_since = Time.zone.parse(changed_since) if changed_since.present?
        @patient_ids = Array(patient_ids)
        @logger = logger || Rails.logger
        @timestamp = Time.zone.now.strftime("%Y%m%d%H%M%S%L")
        @batch ||= Batch.next
        @summary = ExportSummary.new
        @force_send = force_send
      end

      def call
        logger.tagged(batch.number) do
          summary.milliseconds_taken = Benchmark.ms do
            create_patient_xml_files
            encrypt_patient_xml_files
            copy_encrypted_xml_files_into_the_outgoing_folder
          end
          paths.create_symlink_to_latest_timestamped_folder_so_it_is_easier_to_eyeball
          build_summary
          print_summary
          email_summary
        end
      rescue StandardError => e
        # TODO: if fails before copying to outgoing then we should roll back Batch
        Engine.exception_notifier.notify(e)
        raise e
      end

      private

      def paths
        @paths ||= begin
          Paths.new(
            timestamp: timestamp,
            batch_number: batch.number,
            working_path: config.ukrdc_working_path
          )
        end
      end

      # If UKRDC_THREADS is set to a nonzero value (eg 4 but depending on CPUs/cores),
      # a thread pool containing that number of threads is created and XML creation
      # (including PDF letter rendering) for that patient happens in a separate thread.
      # The performance increase in doing it this way is marginal unless there are
      # PDFs to be rendered, which can introduce significant IO wait. As PDFs are cached
      # by the PDFLetterCache, using threads may have limited benefit but
      # rubocop:disable Metrics/AbcSize
      def create_patient_xml_files
        count = 0
        patients = ukrdc_patients_who_have_changed_since_last_send
        summary.num_changed_patients = patients.count
        schema = UKRDC::XsdSchema.new
        thread_count = ENV["UKRDC_THREADS"].to_i
        use_threads = thread_count.nonzero?

        if use_threads
          thread_pool = Concurrent::ThreadPoolExecutor.new(max_threads: thread_count)
        end

        patients.map do |patient|
          count += 1
          Rails.logger.info count
          if use_threads
            thread_pool.post do
              Rails.logger.info "Thread #{Thread.current.object_id}"
              ActiveRecord::Base.connection_pool.with_connection do
                create_xml_file(patient: patient, schema: schema)
              end
            end
          else
            create_xml_file(patient: patient, schema: schema)
          end
        end
      ensure
        if use_threads
          thread_pool.shutdown
          thread_pool.wait_for_termination
        end
      end
      # rubocop:enable Metrics/AbcSize

      def create_xml_file(patient:, schema:)
        CreatePatientXmlFile.new(
          patient: patient,
          dir: paths.timestamped_xml_folder,
          changes_since: changed_since,
          batch: batch,
          logger: logger,
          force_send: force_send,
          schema: schema
        ).call
      end

      def build_summary
        summary.count_of_files_in_outgoing_folder = count_of_files_in_outgoing_folder
        summary.archive_folder = paths.timestamped_folder
        summary.results = export_results
      end

      # rubocop:disable Metrics/AbcSize
      def ukrdc_patients_who_have_changed_since_last_send
        @ukrdc_patients_who_have_changed_since_last_send ||= begin
          logger.info("Finding #{patient_ids&.any? ? patient_ids : 'all ukrdc'} patients")
          query = Renalware::UKRDC::PatientsQuery.new.call(
            changed_since: changed_since,
            changed_since_last_send: !force_send
          )
          query = query.where(id: Array(patient_ids)) if patient_ids.present?

          if changed_since.present?
            if force_send
              logger.info("sending #{query.count} patients, taking changes since #{changed_since}")
            else
              logger.info("#{query.count} patients have changed since #{changed_since}")
            end
          else
            logger.info("#{query.count} patients have changed since the last send")
          end
          query.all
        end
      end
      # rubocop:enable Metrics/AbcSize

      def print_summary
        logger.info("Files saved to #{summary.archive_folder}")
        logger.info "*** Summary ***"
        logger.info "Took #{summary.milliseconds_taken.to_i / 1000} seconds"
        summary.results.map { |key, value| logger.info("#{key}: #{value}") }
      end

      def email_summary
        UKRDC::SummaryMailer.export_summary(
          to: email_recipients,
          summary: summary
        ).deliver_later
      end

      def email_recipients
        Array(ENV.fetch("DAILY_REPORT_EMAIL_RECIPIENTS", "tim@airslie.com").split(","))
      end

      def export_results
        TransmissionLog.where(batch_id: batch.id).group(:status).count(:status).to_h
      end

      def encrypt_patient_xml_files
        logger.info "Encrypting..."
        GpgEncryptFolder.new(folder: paths.timestamped_xml_folder, options: gpg_options).call
      end

      def copy_encrypted_xml_files_into_the_outgoing_folder
        encrypted_files = Dir.glob(paths.timestamped_encrypted_folder.join("*.*"))
        FileUtils.cp_r(encrypted_files, paths.outgoing_folder) if encrypted_files.any?
      end

      def count_of_files_in_outgoing_folder
        Dir.glob(File.join(paths.outgoing_folder, "*.*")).count
      end

      def config
        Renalware.config
      end

      def gpg_options
        GpgOptions.new(
          recipient: config.ukrdc_gpg_recipient,
          public_key_name: config.ukrdc_public_key_name,
          destination_folder: paths.timestamped_encrypted_folder
        )
      end
    end
  end
end
