# frozen_string_literal: true

module Renalware
  module Patients
    describe SyncODSJob do
      include ActiveJob::TestHelper

      describe "#perform" do
        it "delegates to other API and download service object" do
          allow(Renalware::Patients::SyncPracticesViaAPI).to receive(:call)
          allow(Renalware::Patients::SyncGpsViaFileDownloadJob).to receive(:perform_later)

          described_class.perform_now(dry_run: false)

          expect(Renalware::Patients::SyncPracticesViaAPI).to have_received(:call)
          expect(Renalware::Patients::SyncGpsViaFileDownloadJob).to have_received(:perform_later)
        end
      end
    end
  end
end
