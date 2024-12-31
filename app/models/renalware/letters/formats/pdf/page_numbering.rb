module Renalware
  module Letters
    module Formats
      module Pdf
        class PageNumbering
          include Prawn::View
          pattr_initialize :document

          def build(start_count_at: 1)
            string = "Page <page> of <total>"
            options = {
              at: [bounds.right - 150, 0],
              width: 150,
              align: :right,
              start_count_at: start_count_at
            }
            number_pages string, options
          end
        end
      end
    end
  end
end
