module Renalware
  module Letters
    module Formats
      module Pdf
        class Problems
          include Prawn::View
          pattr_initialize :document, :letter, :x, :y, :width
          BULLET = "• ".freeze
          delegate :patient, to: :letter

          def build
            bounding_box([x, y], width: width) do
              pad(10) do
                pad_bottom(5) { text "Problems", style: :bold }
                patient.problems.ordered.pluck(:description).each { |desc| row(desc) }
              end
            end
          end

          def row(text)
            text "#{BULLET} #{text}"
          end
        end
      end
    end
  end
end
