# frozen_string_literal: true

module Renalware
  module Letters::Rendering
    describe PdfRenderer do
      let(:user) { create(:user) }

      def pending_review_letter
        primary_care_physician = create(:letter_primary_care_physician)
        patient = create(
          :patient,
          primary_care_physician: primary_care_physician,
          by: user
        )
        create(
          :pending_review_letter,
          patient: patient.becomes(Letters::Patient),
          main_recipient: build(:letter_recipient, :main),
          by: user
        )
      end

      def approve_letter(letter)
        Letters::ApproveLetter.new(letter).call(by: user)
        Letters::Letter::Approved.find(letter.id)
      end

      context "when the PDF is not archived" do
        it "renders a PDF using prawn" do
          letter = pending_review_letter
          expect(letter).not_to be_archived

          pdf_content = described_class.call(Letters::LetterPresenterFactory.new(letter))

          expect(pdf_content).to start_with("%PDF")
        end
      end

      context "when the letter is archived" do
        it "uses the pdf content in letter_archive.pdf_content rather than rendering afresh" do
          pending "reinstate with prawn"
          letter = pending_review_letter
          letter = approve_letter(letter)
          expect(letter).to be_archived
          expect(letter.archive.pdf_content).to be_present
          allow(letter.archive).to receive(:pdf_content).and_return("Archived pdf content")

          pdf_content = described_class.call(Letters::LetterPresenterFactory.new(letter))

          expect(pdf_content).to start_with("Archived pdf content")
        end
      end
    end
  end
end
