require "collection_presenter"

module Renalware
  module Letters
    module Printing
      # Renders a PDF for printing with interleaved address and letter pages for multiple recipients
      class DuplexInterleavedPdfRenderer
        # Note we can't support page numbers here as they would start on the first address page and
        # end on the last letter, so the last letter if there are 3 recipients might say
        # Page 5 of 6 on the address page and Page 6 of 6 on the letter.
        OPTIONS = {
          page_size: "A4",
          encoding: "UTF-8"
        }.freeze

        def self.call(letter)
          unless letter.respond_to?(:to_html)
            letter = LetterPresenterFactory.new(letter)
          end
          # NB not caching the pdf for now until we can find a more standard way of using the
          # letter cache across adhoc and env stuffer renderers. Here for example we should be
          # using a hex digest of the interleaved letter but currently would not be.
          # PdfLetterCache.fetch(letter) do
          WickedPdf.new.pdf_from_string(
            LettersController.new.render_to_string(
              template: "/renalware/letters/printable_letters/show",
              locals: { letter: letter, recipients: printable_recipients_for(letter) },
              encoding: "UTF-8"
            ),
            OPTIONS
          )
        end

        def self.printable_recipients_for(letter)
          CollectionPresenter.new(
            Recipient.printable_recipients_for(letter),
            RecipientPresenter::WithCurrentAddress
          )
        end
      end
    end
  end
end
