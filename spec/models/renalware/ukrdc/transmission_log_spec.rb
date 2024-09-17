# frozen_string_literal: true

module Renalware
  describe UKRDC::TransmissionLog do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:status)
      is_expected.to belong_to(:patient).touch(false)
      is_expected.to belong_to(:batch).touch(false)
    end

    describe ".with_logging" do
      let(:uuid) { SecureRandom.uuid }

      context "when yielding to the supplied block" do
        context "when there is an exception" do
          it "catches the exception and logs the error message and set the status to 'error'" do
            patient = create(:patient)

            expect {
              described_class.with_logging(
                patient: patient,
                request_uuid: uuid,
                status: :undefined
              ) do
                raise ArgumentError
              end
            }.to raise_error(ArgumentError)

            log = described_class.where(patient_id: patient.id).last

            expect(log.error.first).to match /ArgumentError/
            expect(log.status).to eq("error")
          end
        end

        context "when processing succeeds" do
          it "saves the log" do
            patient = create(:patient)
            described_class.with_logging(patient: patient, request_uuid: uuid) do |log|
              log.payload = "XYZ"
              log.payload_hash = "123"
              log.queued!
            end

            log = described_class.where(patient_id: patient.id).last

            expect(log).to have_attributes(
              payload: "XYZ",
              payload_hash: "123",
              status: "queued"
            )
          end
        end

        context "when unsent because no changes in the xml are found since the last sent" do
          it "saves the log" do
            patient = create(:patient)
            described_class.with_logging(patient: patient, request_uuid: uuid) do |log|
              log.payload = "XYZ"
              log.payload_hash = "123"
              log.skippped_no_change_since_last_send!
            end

            log = described_class.where(patient_id: patient.id).last

            expect(log).to have_attributes(
              payload: "XYZ",
              payload_hash: "123",
              status: "skippped_no_change_since_last_send"
            )
          end
        end
      end
    end
  end
end
