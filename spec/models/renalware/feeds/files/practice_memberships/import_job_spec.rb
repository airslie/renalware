module Renalware
  module Feeds
    module Files
      module PracticeMemberships
        describe ImportJob do
          context "when importing epracmem.zip" do
            let(:import_csv) { instance_double(PracticeMemberships::ImportCSV, call: nil) }

            before do
              allow(PracticeMemberships::ImportCSV).to receive(:new)
                .with(kind_of(Pathname))
                .and_return(import_csv)
            end

            it "calls ImportCSV to do the work" do
              file = create(
                :feed_file,
                :primary_care_physicians,
                location: file_fixture("practice_memberships/epracmem.zip")
              )

              expect {
                described_class.new.perform(file)
              }.to output.to_stdout_from_any_process

              expect(import_csv).to have_received(:call).exactly(:once)
            end
          end
        end
      end
    end
  end
end
