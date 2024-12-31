module Renalware
  module Feeds
    module Files
      describe EnqueueFileForBackgroundProcessing do
        include ActiveJob::TestHelper

        it "enqueues an import job to process the file asynchronously" do
          file = build_stubbed(:feed_file, location: "a file path")
          described_class.call(file)
          expect(enqueued_jobs.size).to eq(1)
        end
      end
    end
  end
end
