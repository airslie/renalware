module Renalware
  module Feeds
    describe PatientListener do
      describe "#patient_added" do
        it "delegates to another object to replay (and thus import) historical pathology" do
          patient = nil
          allow(ReplayHistoricalHL7PathologyMessagesJob).to receive(:perform_later)

          described_class.new.patient_added(patient, "bla")

          expect(ReplayHistoricalHL7PathologyMessagesJob)
            .to have_received(:perform_later).with(patient, "bla")
        end

        context "when replaying pathology messages is disabled via config/ENV var" do
          it "skips the replay" do
            allow(Renalware.config)
              .to receive(:replay_historical_pathology_when_new_patient_added)
              .and_return(false)

            patient = nil
            allow(ReplayHistoricalHL7PathologyMessagesJob).to receive(:perform_later)

            described_class.new.patient_added(patient, "bla")

            expect(ReplayHistoricalHL7PathologyMessagesJob).not_to have_received(:perform_later)
          end
        end
      end
    end
  end
end
