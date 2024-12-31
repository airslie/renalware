module Renalware
  describe ZipArchive do
    def path_to_zipfile(filename)
      Renalware::Engine.root.join("spec", "fixtures", "files", filename)
    end

    describe "#unzip" do
      context "when the zip file contains files" do
        it "yields a hash of pathnames keyed by basename" do
          expect { |block|
            described_class.new(path_to_zipfile("simple.zip")).unzip(&block)
          }.to yield_with_args([Pathname, Pathname])
        end
      end

      # context "when the zip file is in the rar format and has 2 files" do
      #   it "yields a hash of pathnames keyed by basename" do
      #     expect { |block|
      #       described_class.new(path_to_zipfile("simple_rar.zip")).unzip(&block)
      #     }.to yield_with_args([Pathname, Pathname])
      #   end
      # end
    end
  end
end
