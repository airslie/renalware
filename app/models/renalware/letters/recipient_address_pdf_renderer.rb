module Renalware
  module Letters
    class RecipientAddressPdfRenderer
      OPTIONS = {
        page_size: "A4",
        encoding: "UTF-8"
      }.freeze

      def self.call(recipient)
        unless recipient.respond_to?(:to_html)
          recipient = RecipientPresenter::WithCurrentAddress.new(recipient)
        end
        WickedPdf.new.pdf_from_string(
          LettersController.new.render_to_string(
            partial: "/renalware/letters/formatted_letters/recipient_address_cover_sheet",
            locals: { recipient: recipient },
            encoding: "UTF-8"
          ),
          OPTIONS
        )
      end
    end
  end
end
