module Renalware
  module Letters
    module Formats
      module Pdf
        class CarbonCopies
          include Prawn::View
          pattr_initialize :document

          def build
            pad(5) { text("cc:", style: :bold) }

            pad(5) do
              pad_bottom(3) { text "Private and confidential" }
              text "CC name and address here"
              # text "Dr PATEL BK"
              # text "GLYNDON PMS"
              # text "GLYNDON MEDICAL CENTRE"
              # text "188 ANN STREET"
              # text "PLUMSTEAD"
              # text "LONDON"
              # text "GREATER LONDON"
              # text "SE18 7LU"
              # text "VIA EMAIL to G83060@demonhs1000.net"
            end
          end
        end
      end
    end
  end
end
