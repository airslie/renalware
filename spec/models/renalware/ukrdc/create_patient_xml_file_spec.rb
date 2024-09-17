# frozen_string_literal: true

module Renalware
  describe UKRDC::CreatePatientXmlFile do
    let(:user) { create(:user) }
    let(:xml) {
      # This the XML our mock renderer will always render!
      <<-XML
      <xml>
        <SendingFacility channelName='Renalware' time='2018-02-26T13:18:02+00:00'/>
        <AnotherElement some_attribute=''></AnotherElement>
        <LabOrders start="2018-02-23T00:00:00+00:00" stop="2018-02-26T18:35:28+00:00">
        </LabOrders>
        <Observations start="2018-02-23T00:00:00+00:00" stop="2018-02-26T18:35:28+00:00">
        </Observations>
      </xml>
      XML
    }
    let(:xml_with_sending_facility_time_removed) {
      <<-XML
      <xml>
        <SendingFacility channelName='Renalware'/>
        <AnotherElement some_attribute=''></AnotherElement>
        <LabOrders>
        </LabOrders>
        <Observations>
        </Observations>
      </xml>
      XML
    }

    let(:success_result) do
      instance_double(UKRDC::XmlRenderer::Success, xml: xml, success?: true, failure?: false)
    end
    let(:success_renderer) { instance_double(UKRDC::XmlRenderer, call: success_result) }

    let(:failure_result) do
      instance_double(
        UKRDC::XmlRenderer::Failure,
        validation_errors: %i(error1 error2),
        success?: false,
        failure?: true
      )
    end
    let(:failure_renderer) { instance_double(UKRDC::XmlRenderer, call: failure_result) }

    let(:xml_md5_hash) { Digest::MD5.hexdigest(xml_with_sending_facility_time_removed) }
    let(:patient) do
      create(
        :patient,
        ukrdc_external_id: SecureRandom.uuid,
        nhs_number: "9999999999",
        sent_to_ukrdc_at: 1.week.ago,
        practice: create(:practice),
        primary_care_physician: create(:primary_care_physician)
      )
    end

    context "when the patient has never been sent to the UKRDC before" do
      it "'sends' a new XML file and updates the log entry correctly" do
        patient.update_by(user, sent_to_ukrdc_at: nil)
        batch = UKRDC::Batch.next

        Dir.mktmpdir(nil, Rails.root.join("tmp").to_s) do |dir|
          service = described_class.new(
            patient: patient,
            batch: batch,
            dir: dir,
            renderer: success_renderer,
            schema: UKRDC::XsdSchema.new,
            changes_since: "2017-01-01" # required if sent_to_ukrdc_at is nil!
          )

          expect { service.call }.to change(patient, :sent_to_ukrdc_at)

          log = UKRDC::TransmissionLog.where(patient: patient).last
          expect(log.error).to eq([])
          expect(log.payload_hash).to eq(xml_md5_hash)

          expect(log.file_path).to eq(
            File.join(dir, "RJZ_#{batch.number}_#{patient.nhs_number}.xml")
          )
          expect(File.read(log.file_path)).to eq(xml) # Check the correct content was written
        end
      end
    end

    context "when the patient has previously been sent to the UKRDC but now something about has " \
            "cause the XML content to differ" do
      let(:prevous_transmission_log) {
        UKRDC::TransmissionLog.create!(
          patient: patient,
          batch: UKRDC::Batch.next,
          status: :queued,
          created_at: 1.week.ago,
          payload: "<xml>out of date</xml>",
          payload_hash: Digest::MD5.hexdigest("<xml>out of date</xml>")
        )
      }

      it "'sends' a new XML file and updates the log entry correctly" do
        prevous_transmission_log
        batch = UKRDC::Batch.next

        Dir.mktmpdir(nil, Rails.root.join("tmp").to_s) do |dir|
          service = described_class.new(
            batch: batch,
            renderer: success_renderer,
            schema: UKRDC::XsdSchema.new,
            patient: patient,
            dir: dir
          )

          expect { service.call }.to change(patient, :sent_to_ukrdc_at)

          log = UKRDC::TransmissionLog.where(patient: patient).last
          expect(log.error).to eq([])
          expect(log.payload_hash).to eq(xml_md5_hash)

          expect(log.file_path).to eq(
            File.join(dir, "RJZ_#{batch.number}_#{patient.nhs_number}.xml")
          )
          expect(File.read(log.file_path)).to eq(xml) # Check the correct content was written
        end
      end
    end

    context "when the patient has previously been sent to the UKRDC but *nothing* about has " \
            "changes so the payload_hash is the same" do
      let(:prevous_transmission_log) {
        UKRDC::TransmissionLog.create!(
          batch: UKRDC::Batch.next,
          patient: patient,
          status: :queued,
          created_at: 1.week.ago,
          payload: xml,
          payload_hash: xml_md5_hash
        )
      }

      it "does *not* send a new XML file but updates the log entry as unsent" do
        prevous_transmission_log

        Dir.mktmpdir(nil, Rails.root.join("tmp").to_s) do |dir|
          service = described_class.new(
            batch: UKRDC::Batch.next,
            renderer: success_renderer,
            patient: patient,
            schema: UKRDC::XsdSchema.new,
            dir: dir
          )

          expect { service.call }.not_to change(patient, :sent_to_ukrdc_at)

          log = UKRDC::TransmissionLog.where(patient: patient).last
          expect(log.error).to eq([])
          expect(log.payload_hash).to eq(xml_md5_hash)
          expect(log.file_path).to be_nil
        end
      end
    end

    context "when the patient XML has UKRDC XSD validation errors" do
      it "does *not* send a new XML file but updates the log entry as unsent" do
        Dir.mktmpdir(nil, Rails.root.join("tmp").to_s) do |dir|
          service = described_class.new(
            batch: UKRDC::Batch.next,
            renderer: failure_renderer,
            schema: UKRDC::XsdSchema.new,
            patient: patient,
            dir: dir
          )

          expect { service.call }.not_to change(patient, :sent_to_ukrdc_at)

          log = UKRDC::TransmissionLog.where(patient: patient).last
          expect(log.error).to eq(%w(error1 error2))
          expect(log.status).to eq("error")
          expect(log.payload).to be_nil
          expect(log.payload_hash).to be_nil
          expect(log.file_path).to be_nil
        end
      end
    end
  end
end
