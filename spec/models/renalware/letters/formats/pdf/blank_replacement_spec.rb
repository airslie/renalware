require "pdf/reader"

module Renalware::Letters::Formats::Pdf
  describe BlankReplacement do
    include LettersSpecHelper

    describe "#render" do
      it "generates a PDF stating the original letter has been replaced with blank this one" do
        io = StringIO.new(described_class.new.render)

        PDF::Reader.open(io) do |reader|
          expect(reader.page_count).to eq(1)
          expect(reader.pages[0]).to have_pdf_page_text("Original letter has been removed")
        end
      end
    end
  end
end
