module Renalware
  describe Letters::CalculatePageCountJob do
    include LettersSpecHelper
    subject(:job) { described_class }

    let(:patient) { create(:letter_patient) }
    let(:user) { create(:user) }
    let(:letter) do
      create_letter(
        to: :patient,
        patient: patient,
        state: :completed,
        body: "a line of text<br/>" * lines_of_body_text,
        by: user
      ).tap do |lett|
        create(
          :letter_archive,
          letter: lett,
          content: "a line of text<br/>" * lines_of_body_text,
          by: user
        )
      end
    end

    context "when we are using wicked_pdf/wkhtmltopdf for PDF generation" do
      before {
        allow(Renalware.config).to receive(:letters_render_pdfs_with_prawn).and_return(false)
      }

      describe "#letter_approved" do
        context "with a one page letter" do
          let(:lines_of_body_text) { 1 }

          it "renders the letter to PDF and saves the number of pages found" do
            expect {
              job.letter_approved(letter)
            }.to change(letter, :page_count).from(nil).to(1)
          end

          it "saves the pdf_content" do
            job.letter_approved(letter)
            expect(letter.reload.archive.pdf_content).to be_present
            expect(letter.reload.archive.pdf_content).to start_with("%PDF")
          end
        end

        context "with a two page letter" do
          let(:lines_of_body_text) { 80 }

          it "renders the letter to PDF and saves the number of pages found" do
            expect {
              job.letter_approved(letter)
            }.to change(letter, :page_count).from(nil).to(2)
          end
        end
      end

      context "when the letter has been archived" do
        let(:lines_of_body_text) { 1 }

        it "saves the pdf binary data" do
          # Note this might become an inline operation once we switch to Prawn
          job.letter_approved(letter)

          expect(letter.archive.pdf_content).not_to be_nil
        end
      end
    end
  end
end
