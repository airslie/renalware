# frozen_string_literal: true

module Renalware
  module Letters
    module Formats
      module Pdf
        # Creates a letter addressee/recipient cover sheet PDF that will be inserted in front
        # of each copy of the letter. Page 2 is always blank because we as are duplex printing.
        class RecipientAddressPagePdf
          include Prawn::View
          attr_reader :recipient

          def initialize(recipient, parent_document = nil)
            @recipient = recipient
            @document = parent_document || new_document
            build
          end

          def new_document
            Prawn::Document.new(
              page_size: "A4",
              page_layout: :portrait
            )
          end

          private

          def build
            render_recipient_address
            render_blank_second_page
            self
          end

          def render_recipient_address
            presenter = RecipientPresenter.new(recipient)
            bounding_box([29, 696], width: 300) do
              font_size 9
              text "PRIVATE AND CONFIDENTIAL"
              text " "

              presenter
                .address
                .to_a
                .map { |val| replace_characters_not_in_windows1252_charset(val) }
                .each { |line| text line }
            end
          end

          def render_blank_second_page
            start_new_page
          end

          # rubocop:disable Style/AsciiComments
          # Replace characters we can't handle in the default Windows-1252
          # character set used by Prawn (note we should switch to UTF8 but that is a larger change).
          # E.g "Bacău" => "Bac?u"
          def replace_characters_not_in_windows1252_charset(value)
            value&.encode("Windows-1252", invalid: :replace, undef: :replace)
          end
          # rubocop:enable Style/AsciiComments
        end
      end
    end
  end
end
