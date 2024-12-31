module Renalware
  module UKRDC
    class CreatePatientXmlFile
      pattr_initialize [
        :patient!,
        :dir!,
        :schema!,
        :changes_since,
        :logger,
        :batch,
        :renderer, # so we can pass a test renderer to bypass real rendering
        :log,
        :force_send
      ]

      # If force_send is true then send all files even if they have not changed since the last
      # send. This is primarily for debugging and testing phases with UKRDC
      def call
        update_patient_to_indicated_we_checked_them_for_any_relevant_changes
        UKRDC::TransmissionLog.with_logging(patient: patient, batch: batch) do |log|
          @log = log
          logger.info "  Patient #{patient.ukrdc_external_id}"
          xml_payload = build_payload(log)
          if xml_payload.present?
            if !force_send && xml_payload_same_as_last_sent_payload?(xml_payload)
              logger.info "    skipping as no change in XML file"
              log.skippped_no_change_since_last_send!
            else
              create_xml_file(xml_payload, log)
              update_patient_to_indicate_we_have_sent_their_data_to_ukrdc
            end
          end
          logger.info "    Status: #{log.status}"
        end
      end

      private

      def logger
        @logger ||= Rails.logger
      end

      # Important we use update_column here so we don't trigger updated_at to change
      # on the patient, which affects the results of PatientsQuery next time.
      def update_patient_to_indicated_we_checked_them_for_any_relevant_changes
        patient.update_column(:checked_for_ukrdc_changes_at, Time.zone.now)
      end

      # Important we use update_column here so we don't trigger updated_at to change
      # on the patient, which affects the results of PatientsQuery next time.
      def update_patient_to_indicate_we_have_sent_their_data_to_ukrdc
        patient.update_column(:sent_to_ukrdc_at, Time.zone.now)
        logger.info(
          "    sending file and setting patient.sent_to_ukrdc_at = #{patient.sent_to_ukrdc_at}"
        )
      end

      def xml_payload_same_as_last_sent_payload?(payload)
        payload.to_md5_hash == last_sent_transmission_log.payload_hash
      end

      def create_xml_file(payload, log)
        File.write(xml_filepath, payload)
        log.file_path = xml_filepath
        log.queued!
      end

      def last_sent_transmission_log
        @last_sent_transmission_log ||= begin
          TransmissionLog.where(patient: patient,
                                status: :queued).ordered.last || NullObject.instance
        end
      end

      def build_payload(log)
        result = attempt_to_generate_patient_ukrdc_xml
        if result.failure?
          handle_invalid_xml(result)
          nil
        else
          Payload.new(result.xml).tap do |payload|
            # log.payload = payload.to_s
            log.payload_hash = payload.to_md5_hash
          end
        end
      end

      def attempt_to_generate_patient_ukrdc_xml
        (renderer || default_renderer).call
      end

      def handle_invalid_xml(result)
        log.error = result.validation_errors
        log.status = :error
        nil
      end

      def default_renderer
        Renalware::UKRDC::XmlRenderer.new(
          schema: schema,
          locals: { patient: presenter_for(patient) }
        )
      end

      def presenter_for(patient)
        Renalware::UKRDC::PatientPresenter.new(
          patient,
          changes_since: changes_since
        )
      end

      def xml_filepath
        xml_filename = Filename.new(patient: patient, batch_number: batch.number).to_s
        File.join(dir, xml_filename)
      end

      class Payload
        pattr_initialize :payload
        delegate :to_s, to: :payload

        def to_md5_hash
          @to_md5_hash ||= Digest::MD5.hexdigest(time_neutral_payload)
        end

        # Remove the time elements from SendingFacility
        # e.g.
        #   <SendingFacility channelName='Renalware' time='2018-02-26T13:18:02+00:00'/>
        # becomes
        #   <SendingFacility channelName='Renalware'/>
        # This allows us to do payload comparisons independent of the time they were sent.
        def time_neutral_payload
          payload
            .gsub(%r{<Stream>[^<]*</Stream>}, "<Stream>removed</Stream>")
            .gsub(/ (time|start|stop)=["'][^'"]*['"]/, "")
            .gsub(%r{<UpdatedOn>[^<]*</UpdatedOn>}, "<UpdatedOn>removed</UpdatedOn>")
        end
      end
    end
  end
end
