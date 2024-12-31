#
# Render a Letter to PDF using prawn - or return archived pdf_content data if exists.
# Note that if prawn rendering is enabled then we save the pdf binary content to
# letter.archive.pdf_content at the point of letter approval.
# If using WickedPDF instead, the pdf_content column cannot be guaranteed to be populated
# as the pdf is generated in a background job after approval.
#
module Renalware
  module Letters
    module Rendering
      class PdfRenderer
        include Callable
        pattr_initialize :letter

        # If the letter is archived we just return the pdf_content binary data if present
        # (it might be missing on letters created before this change went live).
        # otherwise we render a new PDF.
        def call
          if Rails.env.production?
            raise "Can't use prawn for PDF generation in production yet!"
          end

          archived_pdf_content = letter.archive.pdf_content if letter.archived?
          archived_pdf_content.presence || Formats::Pdf::Document.new(letter, nil).build.render
        end
      end
    end
  end
end
