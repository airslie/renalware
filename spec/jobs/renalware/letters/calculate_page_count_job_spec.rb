# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe Letters::CalculatePageCountJob do
    include LettersSpecHelper
    subject(:job) { described_class }

    let(:patient) { create(:letter_patient) }
    let(:letter) do
      create_letter(
        to: :patient,
        patient: patient,
        state: :completed,
        body: "a line of text<br/>" * lines_of_body_text
      )
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
        end

        context "with a two page letter" do
          let(:lines_of_body_text) { 70 }

          it "renders the letter to PDF and saves the number of pages found" do
            expect {
              job.letter_approved(letter)
            }.to change(letter, :page_count).from(nil).to(2)
          end
        end
      end
    end
  end
end
