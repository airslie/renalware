require "pdf/reader"

module Renalware::Letters::Formats::Pdf
  describe RecipientAddressPagePdf do
    include LettersSpecHelper

    describe "#render" do
      it "generates a PDF letter address cover sheet with a blank second page" do
        letter = create_approved_letter_to_patient_with_cc_to_gp_and_one_contact
        address = letter.main_recipient.address
        address.update!(
          street_1: "1x2x3",
          street_2: "street_2",
          street_3: "XXX",
          town: "O'X",
          postcode: "POSTCODE"
        )

        pdf = described_class.new(letter.main_recipient.reload)

        io = StringIO.new(pdf.render)

        PDF::Reader.open(io) do |reader|
          expect(reader.page_count).to eq(2) # cover sheet and a blank back page
          expect(reader.pages[0]).to have_pdf_page_text(address.street_1)
          expect(reader.pages[0]).to have_pdf_page_text(address.street_2)
          expect(reader.pages[0]).to have_pdf_page_text(address.street_3)
          expect(reader.pages[0]).to have_pdf_page_text(address.town)
          expect(reader.pages[0]).to have_pdf_page_text(address.postcode)
        end
      end

      it "handles characters that are not in the Windows-1252 character set by replacing with ?" do
        letter = create_approved_letter_to_patient_with_cc_to_gp_and_one_contact
        letter.main_recipient.address.update!(street_1: "Bacău")
        pdf = nil

        expect {
          pdf = described_class.new(letter.main_recipient)
        }.not_to raise_error(Prawn::Errors::IncompatibleStringEncoding)

        io = StringIO.new(pdf.render)

        PDF::Reader.open(io) do |reader|
          expect(reader.pages[0].text).to include("Bac?u")
        end
      end
    end
  end
end
