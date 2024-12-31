module Renalware
  module Letters
    module Formats
      module Pdf
        class Allergies
          include Prawn::View
          pattr_initialize :document

          def build
            # pad_bottom(5) { text "Allergies:  No known allergies", style: :bold }
          end
        end
      end
    end
  end
end
