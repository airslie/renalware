module Renalware
  module Letters
    module Formats
      module Pdf
        class BlankReplacement
          include Prawn::View

          def initialize
            @document = Prawn::Document.new(
              page_size: "A4",
              page_layout: :portrait
            )
            build
          end

          private

          attr_reader :document

          def build
            move_down 100
            text "Original letter has been removed.", align: :center, size: 12
            self
          end
        end
      end
    end
  end
end
