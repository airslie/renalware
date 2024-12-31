module Renalware
  module Letters
    class RendererFactory
      def self.renderer_for(letter, format, **)
        letter = ensure_letter_is_a_presenter(letter)

        case format.to_sym
        when :html then Rendering::HtmlRenderer.new(letter)
        when :rtf then Rendering::RTFRenderer.new(letter)
        when :pdf
          if Renalware.config.letters_render_pdfs_with_prawn
            Rendering::PdfRenderer.new(letter)
          else
            Rendering::WickedPdfRenderer.new(letter, **)
          end
        else raise ArgumentError, "unrecognised letter format '#{format}'"
        end
      end

      def self.ensure_letter_is_a_presenter(letter)
        return letter if letter.respond_to?(:to_html)

        LetterPresenterFactory.new(letter)
      end
    end
  end
end
