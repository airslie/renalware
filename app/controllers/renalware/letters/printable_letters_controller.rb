module Renalware
  module Letters
    # Responsible for allowing a user to view/download a printable PDF that can be sent to an
    # envelope stuffer. It will contain interleaved address sheets and letters so that the machine
    # can stuff a letter for each letter recipient.
    class PrintableLettersController < Letters::BaseController
      def show
        letter = find_letter(params[:letter_id])
        authorize letter
        letter = present_letter(letter)
        render_pdf_as_collated_address_sheet_and_letter_for_each_recipient(letter)
      end

      private

      def find_letter(id)
        patient.letters
          .approved
          .with_patient
          .with_main_recipient
          .with_cc_recipients
          .find(id)
      end

      def present_letter(letter)
        LetterPresenterFactory.new(letter)
      end

      def render_pdf_as_collated_address_sheet_and_letter_for_each_recipient(letter)
        send_data(
          Printing::DuplexInterleavedPdfRenderer.call(letter),
          filename: letter.pdf_filename,
          type: "application/pdf",
          disposition: disposition
        )
      end

      def disposition
        params.fetch("disposition", "inline")
      end
    end
  end
end
