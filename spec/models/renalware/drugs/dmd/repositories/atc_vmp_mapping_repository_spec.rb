module Renalware
  module Drugs::DMD
    require "open-uri"

    describe Repositories::AtcVMPMappingRepository do
      describe "#call" do
        let(:test_zip_file) {
          Renalware::Engine.root.join("spec", "fixtures", "files", "nhs_atc_code_mappings.zip")
        }

        let(:temp_zip) { Tempfile.new(["test", ".zip"]) }

        before do
          FileUtils.cp(test_zip_file, temp_zip.path)

          stub_request(:get, described_class::API_ENDPOINT).to_return(
            status: 200,
            body: {
              apiVersion: "1",
              releases: [{ archiveFileUrl: "https://someurl/somefile.zip" }]
            }.to_json
          )
          allow(OpenURI).to receive(:open_uri).and_return temp_zip
        end

        after do
          temp_zip.unlink
        end

        it "returns friendly data" do
          instance = described_class.new
          result = nil
          expect { result = instance.call }.to output.to_stdout_from_any_process

          expect(result.size).to eq 2

          expect(result.first.vmp_code).to eq "41341511000001109"
          expect(result.first.atc_code).to eq "n/a"

          expect(result.second.vmp_code).to eq "VPID"
          expect(result.second.atc_code).to eq "ATC"
        end
      end
    end
  end
end
