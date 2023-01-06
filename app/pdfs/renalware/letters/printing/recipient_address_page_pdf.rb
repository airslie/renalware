# frozen_string_literal: true

module Renalware
  module Letters
    module Printing
      # Creates a letter addressee/recipient cover sheet PDF that will be inserted in front
      # of each copy of the letter. Page 2 is always blank because we as are duplex printing.
      class RecipientAddressPagePdf
        include Prawn::View
        attr_reader :recipient

        def initialize(recipient)
          @recipient = recipient
          build
        end

        def document
          @document ||= Prawn::Document.new(
            page_size: "A4",
            page_layout: :portrait,
            left_margin: 65,
            top_margin: 109
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
          font_size 9
          text "PRIVATE AND CONFIDENTIAL"
          text " "
          presenter.address.to_a.each { |line| text line }
        end

        def render_blank_second_page
          start_new_page
        end
      end
    end
  end
end
