#
# Render a Letter to PDF.
#
module Renalware
  module Letters
    module Rendering
      class WickedPdfRenderer
        include Callable
        attr_reader :letter, :options

        WICKED_OPTIONS = {
          page_size: "A4",
          footer: {
            font_size: 8,
            right: "Page [page] of [topage]"
          },
          encoding: "UTF-8"
        }.freeze

        def initialize(letter, **options)
          @letter = letter
          @options = options
        end

        def call
          # Try and get PDF from the cache first as HTML to PDF conversion is expensive CPU-wise.
          # Here we lean on Letters::Rendering::HtmlRenderer which already renders the letter to
          # html via LetterPresenter#content, and we convert that to PDF
          PdfLetterCache.fetch(letter, **options) do
            WickedPdf.new.pdf_from_string(presented_letter.to_html(**options), WICKED_OPTIONS)
          end
        end

        def presented_letter
          letter.respond_to?(:to_html) ? letter : LetterPresenterFactory.new(letter)
        end
      end
    end
  end
end
