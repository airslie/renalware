# frozen_string_literal: true

require "combine_pdf"

#
# Renders all letters in a batch to a combined PDF with interleaved cover address sheets.
# Pulls PDF data from letter_archive (where it is stored when letter is 'Approved').
#
module Renalware
  module Letters
    module Rendering
      class WickedBatchPdfRenderer
        MAX_PAGE_COUNT = 10

        # TODO: insert blank pages if odd/even etc
        def call(batch) # rubocop:disable Metrics/MethodLength
          raise "Unused?" if 0.to_i == 0

          pdf = CombinePDF.new

          batch.items.each do |item|
            letter = ensure_letter_is_a_presenter(item.letter)
            validate_letter(letter)

            letter.recipients.each do |recipient|
              next if recipient.emailed_at.present?

              pdf << CombinePDF.parse(recipient_cover_sheet_pdf(recipient))
              pdf << CombinePDF.parse(letter.pdf_content)
            end
            item.update(status: :compiled)
          end

          pdf.to_pdf
        end

        private

        def recipient_cover_sheet_pdf(recipient)
          # Pass nil or document so it generates a self-contained PDF
          Formats::Pdf::RecipientAddressPagePdf.new(recipient, nil).render
        end

        # TODO: do we really need this?
        def validate_letter(letter)
          raise "Letter has no page_count" if letter.page_count.to_i.zero?

          if letter.page_count.to_i > MAX_PAGE_COUNT
            raise "Letter page count (#{letter.page_count}) unexpected, max is #{MAX_PAGE_COUNT}"
          end
        end

        def ensure_letter_is_a_presenter(letter)
          return letter if letter.respond_to?(:pdf_content)

          LetterPresenterFactory.new(letter)
        end
      end
    end
  end
end
