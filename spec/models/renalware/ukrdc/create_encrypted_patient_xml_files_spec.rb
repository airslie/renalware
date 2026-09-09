module Renalware
  describe UKRDC::CreateEncryptedPatientXmlFiles do
    let(:failed_patient) do
      create(
        :patient,
        family_name: "Aardvark",
        given_name: "Alice",
        ukrdc_external_id: SecureRandom.uuid,
        send_to_rpv: true,
        sent_to_ukrdc_at: nil,
        updated_at: 1.day.ago
      )
    end

    let(:successful_patient) do
      create(
        :patient,
        family_name: "Beech",
        given_name: "Bob",
        ukrdc_external_id: SecureRandom.uuid,
        send_to_rpv: true,
        sent_to_ukrdc_at: nil,
        updated_at: 1.day.ago
      )
    end

    let(:logger) { ActiveSupport::TaggedLogging.new(Logger.new(File::NULL)) }

    before do
      allow(Rails.error).to receive(:report)
      allow(GpgEncryptFolder).to receive(:new)
        .and_return(instance_double(GpgEncryptFolder, call: nil))
      allow(UKRDC::SummaryMailer).to receive(:export_summary)
        .and_return(instance_double(ActionMailer::MessageDelivery, deliver_later: true))
    end

    around do |example|
      rails_tmp_folder = Rails.root.join("tmp").to_s
      Dir.mktmpdir(nil, rails_tmp_folder) do |dir|
        Renalware.configure { |config| config.ukrdc_working_path = dir }
        example.run
      end
    end

    describe "#call" do
      it "records an error for one patient and continues creating XML files for " \
         "remaining patients" do
        failed_patient
        successful_patient
        allow_patient_xml_creation_to_fail_for_one_patient

        expect {
          described_class.new(logger:).call
        }.not_to raise_error

        expect(UKRDC::TransmissionLog.where(patient: failed_patient).last).to have_attributes(
          status: "error",
          file_path: nil
        )
        expect(UKRDC::TransmissionLog.where(patient: successful_patient).last).to have_attributes(
          status: "queued",
          file_path: a_string_ending_with("#{successful_patient.nhs_number}.xml")
        )
      end
    end

    def allow_patient_xml_creation_to_fail_for_one_patient
      allow(UKRDC::CreatePatientXmlFile).to receive(:new) do |patient:, batch:, dir:, **|
        instance_double(UKRDC::CreatePatientXmlFile).tap do |service|
          allow(service).to receive(:call) do
            create_patient_xml_file(patient:, batch:, dir:)
          end
        end
      end
    end

    def create_patient_xml_file(patient:, batch:, dir:)
      proc do
        UKRDC::TransmissionLog.with_logging(patient:, batch:) do |log|
          if patient == failed_patient
            raise_record_invalid_for_treatment_with_no_modality_code
          else
            log.status = :queued
            log.file_path = File.join(dir, "RJZ_#{batch.number}_#{patient.nhs_number}.xml")
          end
        end
      end.call
    end

    def raise_record_invalid_for_treatment_with_no_modality_code
      treatment = UKRDC::Treatment.new
      treatment.validate
      raise ActiveRecord::RecordInvalid, treatment.errors.full_messages.to_sentence
    end
  end
end
