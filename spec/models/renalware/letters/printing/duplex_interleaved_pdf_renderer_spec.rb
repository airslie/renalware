# frozen_string_literal: true

require "pdf/reader"

module Renalware
  module Letters
    module Printing
      describe DuplexInterleavedPdfRenderer do
        include LettersSpecHelper

        def open_pdf_in_preview(pdf_file)
          debug = false
          if debug
            FileUtils.cp pdf_file.path, "/Users/tim/Desktop/x.pdf"
            `open /Users/tim/Desktop/x.pdf`
          end
        end

        context "when patient is main recipient CCs are the GP and a letter contact " \
                "and the patient's practice has no email address so we snail mail the GP" do
          context "when the letter is only 1 page long" do
            it "renders a PDF containing an address cover sheet + letter for each recipient " \
               "including blank pages where necessary" do
              # practice_email: "x@y.com"
              letter = create_approved_letter_to_patient_with_cc_to_gp_and_one_contact(
                page_count: 1,
                practice_email: nil
              )

              pdf_file = Tempfile.new("merged_pdf", Rails.root.join("tmp"))

              Benchmark.ms do
                File.binwrite(pdf_file, described_class.call(letter))
              end

              open_pdf_in_preview(pdf_file)

              # We expect the following pages
              # MAIN
              # 1. address page for main recipient (patient)
              # 2. a blank page duplex printed on back of address page
              # 3. the one page letter
              # 4. a blank page duplex printed on back of the letter
              # GP
              # 5. address page for gp recipient (because the patient's practice was not emailed)
              # 6. a blank page duplex printed on back address page
              # 7 .the one page letter
              # 8. a blank page duplex printed on back of the letter
              # CONTACT
              # 9. address page for contact
              # 10. a blank page duplex printed on back address page
              # 11 .the one page letter
              # 12. a blank page duplex printed on back of the letter
              #
              reader = PDF::Reader.new(pdf_file.path)
              expect(reader.page_count).to eq(12)
              pages = reader.pages

              # Page 1 is the main recipient address sheet
              # Address cover sheets should not have a page number
              expect(pages[0]).to have_pdf_page_text("John Smith A B C D E F")
              expect(pages[0]).not_to have_pdf_page_text("Page 1 of")

              # Page 2 is blank
              expect(pages[1].text).to be_blank

              # Page 3 is a copy of the letter
              expect(pages[2]).not_to have_pdf_page_text("Page 1 of")
              expect(pages[2]).to have_pdf_page_text("Yours sincerely")

              # Because we created the practice with an no email address, the letter will be snail
              # mailed to them, but even so we should ot be output
              # there so does not need printing and will not appear on the letter here (it would
              # still appear on the html-viewed and archived versions though)
              expect(pages[2]).to have_pdf_page_text("Dr GOOD PJ")
              expect(pages[2]).to have_pdf_page_text("Jane Contact")

              # Page 4 is blank
              expect(pages[3].text).to be_blank

              # Page 5 is the GP contact cover page
              expect(pages[4]).to have_pdf_page_text(
                "Dr GOOD PJ Trumpton Medical Centre 123 Legoland Brewster Road " \
                "Brownswater Windsor Berkshire NW1 6BB"
              )

              # Page 6 is blank
              expect(pages[5].text).to be_blank

              # Page 7 is the letter
              expect(pages[6]).to have_pdf_page_text("Yours sincerely")

              # Page 8 is blank
              expect(pages[7].text).to be_blank

              # Page 9 is address page for the letter contact
              expect(pages[8]).to have_pdf_page_text("Jane Contact 1 2 3 4 5 6")

              # Page 10 is blank
              expect(pages[9].text).to be_blank

              # Page 11 is the letter
              expect(pages[10]).to have_pdf_page_text("Yours sincerely")

              # Page 12 is blank
              expect(pages[11].text).to be_blank
            end
          end

          context "when the letter spans 2 pages" do
            it "renders a PDF containing an address cover sheet + letter for each recipient " \
               "including blank pages where necessary" do
              # update body to tip the page across 2 pages
              letter = create_approved_letter_to_patient_with_cc_to_gp_and_one_contact(
                body: "xxxxxxxx " * 1100,
                page_count: 2
              )
              pdf_file = Tempfile.new("merged_pdf", Rails.root.join("tmp"))

              Benchmark.ms do
                File.binwrite(pdf_file, described_class.call(letter))
              end

              open_pdf_in_preview(pdf_file)

              reader = PDF::Reader.new(pdf_file.path)

              # We expect the following pages
              # 1. address page for main recipient (patient)
              # 2. a blank page duplex printed on back address page
              # 3. the one page letter
              # 4. a blank page duplex printed on back of the letter
              # 5. address page for gp recipient (becuase the patient's practice was not emailed)
              # 6. a blank page duplex printed on back address page
              # 7 .the one page letter
              # 8. a blank page duplex printed on back of the letter
              # 9. address page for contact
              # 10. a blank page duplex printed on back address page
              # 11 .the one page letter
              # 12. a blank page duplex printed on back of the letter
              expect(reader.page_count).to eq(12)
              pages = reader.pages

              # Page 1 is the main recpient address sheet
              # Address cover sheets should not have a page number
              expect(pages[0]).not_to have_pdf_page_text("Page 1 of")
              expect(pages[0]).to have_pdf_page_text("John Smith A B C D E F")

              # Page 2 is blank
              expect(pages[1].text).to be_blank

              # Page 3 is a copy of the letter
              expect(pages[2]).to have_pdf_page_text("PRIVATE AND CONFIDENTIAL")
              # Note we don't support page numbers when building a combined PDF this way so check
              # they aren't there
              expect(pages[2]).not_to have_pdf_page_text("Page 1 of")

              # Page 4 is the final page of the letter
              expect(pages[3]).to have_pdf_page_text("Yours sincerely")

              # Page 5 is the GP contact
              expect(pages[4]).to have_pdf_page_text(
                "Dr GOOD PJ Trumpton Medical Centre 123 Legoland Brewster Road " \
                "Brownswater Windsor Berkshire NW1 6BB"
              )

              # Page 6 is blank - the back of the address sheet
              expect(pages[5].text).to be_blank

              # Page 7 is the letter page 1
              expect(pages[6]).to have_pdf_page_text("PRIVATE AND CONFIDENTIAL")

              # Page 8 is letter last page
              expect(pages[7]).to have_pdf_page_text("Yours sincerely")

              # Page 9 is address page for the letter contact
              expect(pages[8]).to have_pdf_page_text("Jane Contact 1 2 3 4 5 6")

              # Page 10 is blank
              expect(pages[9].text).to be_blank

              # Page 11 is the letter
              expect(pages[10]).to have_pdf_page_text("PRIVATE AND CONFIDENTIAL")

              # Page 12 is letter last page
              expect(pages[11]).to have_pdf_page_text("Yours sincerely")
            end
          end
        end

        context "when patient is main recipient CCs are the GP and a letter contact " \
                "and the patient's practice has an email address so the GP will not be printed" do
          context "when the letter is only 1 page long" do
            it "renders a PDF containing an address cover sheet + letter for each recipient " \
               "including blank pages where necessary but excluding GP copy" do
              # practice_email: "x@y.com"
              letter = create_approved_letter_to_patient_with_cc_to_gp_and_one_contact(
                page_count: 1,
                practice_email: "x@y.com"
              )

              pdf_file = Tempfile.new("merged_pdf", Rails.root.join("tmp"))

              File.binwrite(pdf_file, described_class.call(letter))

              open_pdf_in_preview(pdf_file)

              # We expect the following pages
              # 1. address page for main recipient (patient)
              # 2. a blank page duplex printed on back address page
              # 3. the one page letter
              # 4. a blank page duplex printed on back of the letter
              # 5. address page for contact
              # 6. a blank page duplex printed on back address page
              # 7 .the one page letter
              # 8. a blank page duplex printed on back of the letter
              reader = PDF::Reader.new(pdf_file.path)
              expect(reader.page_count).to eq(8)
              pages = reader.pages

              # Page 1 is the main recipient address sheet
              # Address cover sheets should not have a page number
              expect(pages[0]).to have_pdf_page_text("John Smith A B C D E F")
              expect(pages[0]).not_to have_pdf_page_text("Page 1 of")

              # Page 2 is blank
              expect(pages[1].text).to be_blank

              # Page 3 is a copy of the letter
              expect(pages[2]).not_to have_pdf_page_text("Page 1 of")
              expect(pages[2]).to have_pdf_page_text("Yours sincerely")

              # Because we created the practice with an no email address, the letter will be snail
              # mailed to them, but even so we should ot be output
              # there so does not need printing and will not appear on the letter here (it would
              # still appear on the html-viewed and archived versions though)
              expect(pages[2]).to have_pdf_page_text("Dr GOOD PJ")
              expect(pages[2]).to have_pdf_page_text("Jane Contact")

              # Page 4 is blank
              expect(pages[3].text).to be_blank

              # Page 5 is address page for the letter contact
              expect(pages[4]).to have_pdf_page_text("Jane Contact 1 2 3 4 5 6")

              # Page 6 is blank
              expect(pages[5].text).to be_blank

              # Page 7 is the letter
              expect(pages[6]).to have_pdf_page_text("Yours sincerely")

              # Page 8 is blank
              expect(pages[7].text).to be_blank
            end
          end
        end

        context "when patient is main recipient CCs are the GP and a letter contact " \
                "and the GP copy has been sent using GP Connect over MESH ie " \
                "gp_send_status = success" do
          context "when the letter is only 1 page long" do
            it "renders a PDF containing an address cover sheet + letter for each recipient " \
               "including blank pages where necessary but excluding GP copy" do
              # practice_email: "x@y.com"
              letter = create_approved_letter_to_patient_with_cc_to_gp_and_one_contact(
                page_count: 1,
                practice_email: nil,
                gp_send_status: "success"
              )

              pdf_file = Tempfile.new("merged_pdf", Rails.root.join("tmp"))

              File.binwrite(pdf_file, described_class.call(letter))

              open_pdf_in_preview(pdf_file)

              # We expect the following pages
              # 1. address page for main recipient (patient)
              # 2. a blank page duplex printed on back address page
              # 3. the one page letter
              # 4. a blank page duplex printed on back of the letter
              # 5. address page for contact
              # 6. a blank page duplex printed on back address page
              # 7 .the one page letter
              # 8. a blank page duplex printed on back of the letter
              reader = PDF::Reader.new(pdf_file.path)
              expect(reader.page_count).to eq(8)
              pages = reader.pages

              # Page 1 is the main recipient address sheet
              # Address cover sheets should not have a page number
              expect(pages[0]).to have_pdf_page_text("John Smith A B C D E F")
              expect(pages[0]).not_to have_pdf_page_text("Page 1 of")

              # Page 2 is blank
              expect(pages[1].text).to be_blank

              # Page 3 is a copy of the letter
              expect(pages[2]).not_to have_pdf_page_text("Page 1 of")
              expect(pages[2]).to have_pdf_page_text("Yours sincerely")

              # Because we created the practice with an no email address, the letter will be snail
              # mailed to them, but even so we should ot be output
              # there so does not need printing and will not appear on the letter here (it would
              # still appear on the html-viewed and archived versions though)
              expect(pages[2]).to have_pdf_page_text("Dr GOOD PJ")
              expect(pages[2]).to have_pdf_page_text("Jane Contact")

              # Page 4 is blank
              expect(pages[3].text).to be_blank

              # Page 5 is address page for the letter contact
              expect(pages[4]).to have_pdf_page_text("Jane Contact 1 2 3 4 5 6")

              # Page 6 is blank
              expect(pages[5].text).to be_blank

              # Page 7 is the letter
              expect(pages[6]).to have_pdf_page_text("Yours sincerely")

              # Page 8 is blank
              expect(pages[7].text).to be_blank
            end
          end
        end
      end
    end
  end
end
