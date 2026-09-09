module Renalware
  module Patients
    describe SyncODSJob do
      include ActiveJob::TestHelper

      describe "#perform" do
        it "synchronises all ODS data through DSE" do
          synchroniser = instance_double(ODS::DSE::Synchroniser, call: nil)
          allow(ODS::DSE::Synchroniser).to receive(:new).and_return(synchroniser)

          described_class.perform_now(dry_run: false)

          expect(ODS::DSE::Synchroniser).to have_received(:new).with(dry_run: false)
          expect(synchroniser).to have_received(:call)
        end

        it "retries transient DSE validation failures" do
          synchroniser = instance_double(ODS::DSE::Synchroniser)
          allow(ODS::DSE::Synchroniser).to receive(:new).and_return(synchroniser)
          allow(synchroniser).to receive(:call).and_raise(
            ODS::DSE::ValidationError,
            "truncated report"
          )

          expect {
            described_class.perform_now(dry_run: false)
          }.to have_enqueued_job(described_class)
        end
      end
    end
  end
end
