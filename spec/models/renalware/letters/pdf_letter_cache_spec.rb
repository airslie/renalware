module Renalware
  module Letters
    describe PdfLetterCache do
      describe ".fetch" do
        it "uses Rails.cache with a PDF-specific key prefix" do
          patient = Struct.new(:id).new(1)
          html = "<html>Letter</html>"
          letter = Struct.new(:patient, :id, :updated_at, keyword_init: true) do
            define_method(:to_html) { html }
          end.new(
            patient:,
            id: 2,
            updated_at: Time.zone.parse("2026-03-25 10:30:45")
          )

          allow(Rails.cache).to receive(:fetch).and_return("pdf-bytes")

          described_class.fetch(letter)

          expect(Rails.cache).to have_received(:fetch).with(
            "letter_pdf-patient-1-letter-2-pdf",
            version: "20260325103045-#{Digest::MD5.hexdigest(html)}",
            expires_in: 4.weeks
          )
        end
      end
    end
  end
end
