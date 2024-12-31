module Renalware
  module Letters
    module Formats
      module Pdf
        class Signature
          include Prawn::View
          pattr_initialize :document, [:signature!, :position]

          def build
            pad_bottom(20) { text "Yours sincerely" }
            text signature, style: :bold
            text(position) if position.present?
          end
        end
      end
    end
  end
end
